# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  before_action :set_booking

  # POST /bookings/:booking_id/payments
  def create
    current = current_user

    # Authorization: only the renter can pay
    unless current == @booking.renter
      redirect_to "/dashboard",
                  alert: "You are not authorized to pay for this booking"
      return
    end

    payment = @booking.payments.build(
      payer:         current,
      payee:         @booking.owner,
      payment_type:  payment_params[:payment_type], # "deposit" from spec
      dollar_amount: 100.0,                         # simple placeholder amount
      status:        "succeeded"
    )

    # Fields required by your Payment validations for succeeded status
    payment.reference_code = SecureRandom.hex(8)
    payment.settled_at     = Time.current

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
end
