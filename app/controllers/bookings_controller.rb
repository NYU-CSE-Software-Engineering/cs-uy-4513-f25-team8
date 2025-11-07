class BookingsController < ApplicationController
  skip_forgery_protection only: :create

  def create
    booking = Booking.new(booking_params)

    if booking.save
      render inline: "Booking request submitted"
    else
      render inline: "Error: #{booking.errors.full_messages.join(', ')}", status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.permit(:item_id, :renter_id, :owner_id, :start_date, :end_date)
  end
end
