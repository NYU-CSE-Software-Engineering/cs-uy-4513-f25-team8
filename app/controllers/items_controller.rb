class ItemsController < ApplicationController
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
