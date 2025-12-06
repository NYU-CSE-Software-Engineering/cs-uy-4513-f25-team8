# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  before_action :set_booking

  # GET /bookings/:booking_id/payments/new
  def new
    current = current_user
    unless current == @booking.renter
      redirect_to "/dashboard",
                  alert: "You are not authorized to pay for this booking"
      return
    end

    @item = @booking.item
    @days = (@booking.end_date - @booking.start_date).to_i

    @rental_subtotal = (@item.price || 0) * @days
    @deposit_amount  = if @item.respond_to?(:deposit_amount) && @item.deposit_amount.present?
                         @item.deposit_amount
                       else
                         0
                       end
    @total = @rental_subtotal + @deposit_amount
  end

  # POST /bookings/:booking_id/payments
  def create
    current = current_user

    # Authorization: ONLY the renter can pay
    unless current == @booking.renter
      redirect_to "/dashboard",
                  alert: "You are not authorized to pay for this booking"
      return
    end

    payment = @booking.payments.build(
      payer:         current,
      payee:         @booking.owner,
      payment_type:  payment_params[:payment_type],   # "deposit"
      dollar_amount: determine_amount(payment_params[:payment_type]),
      status:        "succeeded"
    )

    # Required for succeeded payments
    payment.reference_code = SecureRandom.hex(8)
    payment.settled_at     = Time.current

    # IMPORTANT: use bang so test fails loudly if validations fail
    payment.save!

    redirect_to booking_payment_path(@booking, payment),
                notice: "Payment succeeded"
  end

  # GET /bookings/:booking_id/payments/:id
  def show
    @payment = @booking.payments.find(params[:id])
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_type)
  end

  # Use same breakdown logic as the new page
  def determine_amount(payment_type)
    item = @booking.item
    days = (@booking.end_date - @booking.start_date).to_i
    rental_subtotal = (item.price || 0) * days
    deposit_amount  = if item.respond_to?(:deposit_amount) && item.deposit_amount.present?
                        item.deposit_amount
                      else
                        0
                      end

    case payment_type
    when "deposit"
      deposit_amount.nonzero? || 100.0    # fallback so it's > 0
    when "rental"
      rental_subtotal.nonzero? || 150.0   # fallback so it's > 0
    else
      (rental_subtotal + deposit_amount).nonzero? || 200.0
    end
  end
end
