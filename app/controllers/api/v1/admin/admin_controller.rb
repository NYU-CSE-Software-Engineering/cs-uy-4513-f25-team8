class Api::V1::Admin::AdminController < ApplicationController
  before_action :authenticate_user_for_api
  before_action :ensure_admin

  def ban
    username = params[:account_username]
    enable = params[:enable] == 'true' || params[:enable] == true
    
    user = User.find_by(username: username)
    
    if user.nil?
      render json: { success: false, error: "User not found" }, status: :not_found
      return
    end

    new_status = enable ? 'active' : 'disabled'
    if user.update(account_status: new_status)
      render json: { success: true }
    else
      render json: { success: false, error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user_for_api
    unless user_signed_in?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end

  def ensure_admin
    unless current_user&.role == 'admin'
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end

