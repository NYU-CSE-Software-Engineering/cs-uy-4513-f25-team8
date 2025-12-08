class BookingsController < ApplicationController
  skip_forgery_protection only: :create

  before_action :authenticate_user!
  before_action :set_booking, only: [:approve, :decline]
  before_action :set_item, only: [:new, :create]

  def new
    return unless @item # Guard clause - redirect already handled in set_item
    
    @booking = Booking.new
    @booking.item_id = @item.id
    @booking.renter_id = current_user.id
    @booking.owner_id = @item.owner_id
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.item = @item
    @booking.renter_id = current_user.id
    @booking.owner_id = @item.owner_id
    @booking.status ||= :requested

    if @booking.save
      redirect_to booking_path(@booking), notice: "Booking request submitted successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @bookings_as_owner = current_user.bookings_as_owner.order(created_at: :desc)
    @bookings_as_renter = current_user.bookings_as_renter.order(created_at: :desc)
  end

  def show
    @booking = Booking.find(params[:id])
    @item = @booking.item
  end

  def approve
    # Ensure only the owner can approve bookings
    unless @booking.owner_id == current_user.id
      redirect_to bookings_path, alert: "You are not authorized to approve this booking."
      return
    end

    if @booking.update(status: :approved)
      redirect_to bookings_path, notice: "Booking approved successfully!"
    else
      redirect_to bookings_path, alert: "Error: #{@booking.errors.full_messages.join(', ')}"
    end
  end

  def decline
    # Ensure only the owner can decline bookings
    unless @booking.owner_id == current_user.id
      redirect_to bookings_path, alert: "You are not authorized to decline this booking."
      return
    end

    # Only requested bookings can be declined
    unless @booking.status == 'requested'
      redirect_to bookings_path, alert: "Only requested bookings can be declined."
      return
    end

    decline_reason = params[:decline_reason]
    
    if decline_reason.blank?
      redirect_to bookings_path, alert: "Please provide a reason for declining the booking."
      return
    end

    if @booking.update(status: :declined, decline_reason: decline_reason)
      redirect_to bookings_path, notice: "Booking declined successfully."
    else
      redirect_to bookings_path, alert: "Error: #{@booking.errors.full_messages.join(', ')}"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:item_id, :renter_id, :owner_id, :start_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_item
    item_id = params[:item_id] || params.dig(:booking, :item_id)
    
    unless item_id.present?
      redirect_to items_path, alert: "Item ID is required."
      return
    end
    
    begin
      @item = Item.find(item_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to items_path, alert: "Item not found."
      return
    end
  end
end
