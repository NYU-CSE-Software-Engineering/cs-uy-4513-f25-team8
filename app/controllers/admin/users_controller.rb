class Admin::UsersController < ApplicationController
  include AdminAuthorization

  def index
    @users = User.all.order(created_at: :desc)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("username LIKE ? OR email LIKE ?", search_term, search_term)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(account_status: params[:account_status])
      status_text = params[:account_status] == 'disabled' ? 'disabled' : 'enabled'
      redirect_to admin_user_path(@user), notice: "User #{@user.username}'s account has been #{status_text}."
    else
      redirect_to admin_user_path(@user), alert: "Failed to update user status."
    end
  end
end

