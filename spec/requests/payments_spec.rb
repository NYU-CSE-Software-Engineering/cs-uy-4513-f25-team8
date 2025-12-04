# spec/requests/payments_spec.rb
require "rails_helper"

RSpec.describe "Payments", type: :request do
  let(:renter) do
    User.create!(
      username: "renter_user",
      role:     "renter",
      email:    "renter@example.com",
      password: "password123"
    )
  end

  let(:owner) do
    User.create!(
      username: "owner_user",
      role:     "owner",
      email:    "owner@example.com",
      password: "password123"
    )
  end

  let(:item) do
    Item.create!(
      title: "Camera",
      price: 50.0,
      owner: owner
    )
  end

  let(:booking) do
    Booking.create!(
      item:       item,
      renter:     renter,
      owner:      owner,
      start_date: Date.today,
      end_date:   Date.today + 3
    )
  end

  # helper to stub authentication
  def login_as(user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end

  describe "POST /bookings/:booking_id/payments" do
    it "creates a succeeded payment when renter submits valid details" do
      login_as(renter)

      expect {
        post booking_payments_path(booking), params: {
          payment: { payment_type: "deposit" }
        }
      }.to change(Payment, :count).by(1)

      payment = Payment.last
      expect(payment.booking).to eq(booking)
      expect(payment.payer).to   eq(renter)
      expect(payment.payee).to   eq(owner)
      expect(payment.payment_type).to eq("deposit")
      expect(payment.status).to       eq("succeeded")
      expect(payment.dollar_amount).to be > 0
      expect(payment.reference_code).to be_present
      expect(payment.settled_at).to be_present

      expect(response).to redirect_to(booking_payment_path(booking, payment))
    end

    it "does NOT allow a different user to pay for the booking" do
      intruder = User.create!(
        username: "intruder_user",
        role:     "renter",
        email:    "intruder@example.com",
        password: "password123"
      )
      login_as(intruder)

      expect {
        post booking_payments_path(booking), params: {
          payment: { payment_type: "deposit" }
        }
      }.not_to change(Payment, :count)

      expect(response).to redirect_to("/dashboard")
    end
  end
end
