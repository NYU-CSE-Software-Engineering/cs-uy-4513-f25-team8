class BookingsController < ApplicationController
  skip_forgery_protection only: :create

  before_action :set_booking, only: [:approve]
  def create
    item = Item.find_by(id: booking_params[:item_id])
    @booking = Booking.new(booking_params.except(:item_id).merge(item: item))
    @booking.status ||= :requested

    if @booking.save
      render inline: "<h1>Booking request submitted</h1>"
    else
      render inline: "Error: #{@booking.errors.full_messages.join(', ')}", status: :unprocessable_entity
    end
  end

  def approve
    if @booking.update(status: :approved)
      render inline: "Booking approved"
    else
      render inline: "Error: #{@booking.errors.full_messages.join(', ')}", status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.permit(:item_id, :renter_id, :owner_id, :start_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
