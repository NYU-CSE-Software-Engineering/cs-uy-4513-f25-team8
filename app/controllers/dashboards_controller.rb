class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @items = @user.items.order(created_at: :desc).limit(10)
    @bookings_as_renter = @user.bookings_as_renter.order(created_at: :desc).limit(10)
    @bookings_as_owner = @user.bookings_as_owner.order(created_at: :desc).limit(10)
  end
end
