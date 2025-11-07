class BookingsController < ApplicationController
  skip_forgery_protection only: :create

  def create
    @booking = Booking.new(booking_params)
    @booking.status ||= :requested

    if @booking.save
      render :create # renders create.html.erb
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
