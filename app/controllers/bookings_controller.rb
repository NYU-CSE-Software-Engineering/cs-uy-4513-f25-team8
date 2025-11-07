class BookingsController < ApplicationController
  skip_forgery_protection only: :create

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
    booking = Booking.find(params[:id])
    booking.update!(status: :approved)

    # TODO: Send notification to renter
    render inline: "Booking approved"
  end

  private
  def booking_params
    params.permit(:item_id, :renter_id, :owner_id, :start_date, :end_date)
  end
end
