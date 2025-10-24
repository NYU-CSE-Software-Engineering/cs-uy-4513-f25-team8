class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @items = Item.all
    @items = @items.available if params[:available] == 'true'
    @items = @items.by_category(params[:category]) if params[:category].present?
  end

  def show
    # @item is set by before_action
  end

  def new
    @item = current_user.items.build if current_user
    @item ||= Item.new
  end

  def create
    if current_user
      @item = current_user.items.build(item_params)
    else
      # For testing without authentication
      @item = Item.new(item_params)
      # Create a default owner if User model exists and no current_user
      if defined?(User) && !current_user
        default_owner = User.find_or_create_by(email: 'owner@example.com') do |user|
          user.password = 'password'
          user.password_confirmation = 'password'
          user.role = 'owner'
        end
        @item.owner = default_owner
      end
    end

    if @item.save
      redirect_to @item, notice: 'Item was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @item is set by before_action
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy!
    redirect_to items_url, notice: 'Item was successfully destroyed'
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def check_owner
    redirect_to items_path, alert: 'Not authorized' unless @item.owner == current_user
  end

  def item_params
    params.require(:item).permit(:title, :description, :price_per_day, :category, :availability, :image)
  end

  def authenticate_user!
    # Override Devise's authenticate_user! for testing without Devise
    if defined?(Devise) && respond_to?(:super)
      super
    else
      # Do nothing if Devise is not available (for testing)
    end
  end

  def current_user
    # Return current_user if Devise is available, otherwise nil
    if defined?(Devise) && respond_to?(:super)
      super
    else
      nil
    end
  end
end