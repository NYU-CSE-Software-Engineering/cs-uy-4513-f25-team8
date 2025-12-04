require "rails_helper"

RSpec.describe Payment, type: :model do
  let(:renter) { User.create!(email: "renter@example.com", password: "password") }
  let(:owner)  { User.create!(email: "owner@example.com",  password: "password") }
  let(:booking) do
    # Adjust attributes to match your Booking model
    Booking.create!(
      item: Item.create!(owner: owner, title: "Camera", price_per_day: 50),
      renter: renter,
      start_date: Date.today,
      end_date: Date.today + 3.days,
      status: "approved"
    )
  end

  it "is invalid without required fields" do
    payment = Payment.new
    expect(payment).not_to be_valid
    expect(payment.errors[:booking]).to be_present
    expect(payment.errors[:payer]).to be_present
    expect(payment.errors[:payee]).to be_present
    expect(payment.errors[:dollar_amount]).to be_present
  end

  it "requires dollar_amount > 0" do
    payment = Payment.new(
      booking: booking,
      payer: renter,
      payee: owner,
      dollar_amount: 0,
      payment_type: :deposit,
      status: :pending
    )
    expect(payment).not_to be_valid
    expect(payment.errors[:dollar_amount]).to be_present
  end

  it "requires reference_code and settled_at when status is succeeded" do
    payment = Payment.new(
      booking: booking,
      payer: renter,
      payee: owner,
      dollar_amount: 100,
      payment_type: :deposit,
      status: :succeeded
    )

    expect(payment).not_to be_valid
    expect(payment.errors[:reference_code]).to be_present
    expect(payment.errors[:settled_at]).to be_present
  end

  it "defaults payment_method to 'simulated'" do
    payment = Payment.new(
      booking: booking,
      payer: renter,
      payee: owner,
      dollar_amount: 100,
      payment_type: :deposit,
      status: :pending
    )
    payment.validate
    expect(payment.payment_method).to eq("simulated")
  end
end
