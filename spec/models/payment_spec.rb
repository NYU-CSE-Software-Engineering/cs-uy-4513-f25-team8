require "rails_helper"

RSpec.describe Payment, type: :model do
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
      price: 25.0,
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

  it "is invalid without required fields" do
    payment = Payment.new

    expect(payment).not_to be_valid
    expect(payment.errors[:booking]).to be_present
    expect(payment.errors[:payer]).to be_present
    expect(payment.errors[:payee]).to be_present
    expect(payment.errors[:dollar_amount]).to be_present
    expect(payment.errors[:payment_type]).to be_present
    expect(payment.errors[:status]).to be_present
  end

  it "requires dollar_amount > 0" do
    payment = Payment.new(
      booking:       booking,
      payer:         renter,
      payee:         owner,
      payment_type:  "deposit",
      status:        "pending",
      dollar_amount: 0
    )

    expect(payment).not_to be_valid
    expect(payment.errors[:dollar_amount]).to be_present
  end

  it "requires reference_code and settled_at when status is succeeded" do
    payment = Payment.new(
      booking:       booking,
      payer:         renter,
      payee:         owner,
      payment_type:  "deposit",
      status:        "succeeded",
      dollar_amount: 100
    )

    expect(payment).not_to be_valid
    expect(payment.errors[:reference_code]).to be_present
    expect(payment.errors[:settled_at]).to be_present
  end

  it "defaults payment_method to 'simulated'" do
    payment = Payment.create!(
      booking:       booking,
      payer:         renter,
      payee:         owner,
      payment_type:  "deposit",
      status:        "pending",
      dollar_amount: 100
    )

    expect(payment.payment_method).to eq("simulated")
  end
end
