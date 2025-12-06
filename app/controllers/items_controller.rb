class ItemsController < ApplicationController
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
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to @item, notice: "Item was successfully created"
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:title, :price, :description, :availability_status, :category, :image)
  end
end
