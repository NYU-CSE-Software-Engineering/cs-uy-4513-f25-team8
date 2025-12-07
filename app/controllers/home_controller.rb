class HomeController < ApplicationController
  def index
    unless user_signed_in?
      return
    end

    if current_user.role == "renter"
      @active_rentals = current_user.active_rentals
      @past_rentals = current_user.past_rentals
    elsif current_user.role == "owner"
      @active_loans = current_user.active_loans
      @past_loans = current_user.past_loans
    end
  end
end
