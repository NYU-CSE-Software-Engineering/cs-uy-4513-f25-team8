class ItemsController < ApplicationController
  # Ensure user is logged in before certain actions
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @items = Item.all
    @items = @items.search_by_keyword(params[:keyword]) if params[:keyword].present?
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
    @items = @items.available_between(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    @items = @items.filter_by_availability unless params[:start_date].present? || params[:end_date].present?
  end

  def new
    @item = Item.new
  end

  def create
    # current_user is guaranteed to exist because of authenticate_user!
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to @item, notice: "Item was successfully created"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Item was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Item was successfully deleted"
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def ensure_owner
    unless @item.owner_id == current_user.id
      redirect_to @item, alert: "You are not authorized to perform this action."
    end
  end

  def item_params
    params.require(:item).permit(:title, :price, :description, :availability_status, :category, :image, :available_from, :available_to, :payment_methods, :deposit_amount)
  end
end
