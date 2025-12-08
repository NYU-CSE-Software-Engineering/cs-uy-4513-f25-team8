class Admin::ItemsController < ApplicationController
  include AdminAuthorization

  def destroy
    @item = Item.find(params[:id])
    item_title = @item.title
    owner = @item.owner
    
    if @item.destroy
      owner.increment!(:report_count)
      redirect_to admin_users_path, notice: "The listing '#{item_title}' has been successfully removed."
    else
      redirect_to item_path(@item), alert: "Failed to remove listing."
    end
  end
end

