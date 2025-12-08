class UsersController < ApplicationController
  def new
    session[:return_to] ||= root_path
    @user = User.new
  end
  def create
    @user = User.new(user_params)

    if @user.save
        session[:user_id] = @user.id  
        flash[:notice] = "Account successfully created"
        redirect_to root_path
    else
        flash.now[:alert] = "Account name is invalid"
        render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :role, :password, :password_confirmation)
  end
end
