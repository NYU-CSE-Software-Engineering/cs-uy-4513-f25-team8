# spec/requests/bookings_spec.rb
require "rails_helper"

RSpec.describe "Bookings", type: :request do
  describe "POST /bookings" do
    it "creates a booking with status requested and shows success message" do
      # Setup: create users and item
      renter = User.create!(username: "isabelle", role: "renter", email: "isabele@example.com", password: "password")
      owner = User.create!(username: "erfu", role: "owner", email: "erfu@example.com", password: "password")
      item = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "available", payment_methods: "credit_card", deposit_amount: 0)

      # Sign in as renter
      sign_in renter

      # Make the POST request
      post "/bookings", params: {
        item_id: item.id,
        booking: {
          start_date: "2025-03-21",
          end_date: "2025-06-21"
        }
      }

      # Verify response - should redirect after successful creation
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(booking_path(Booking.last))
      follow_redirect!
      expect(response.body).to include("Booking request submitted successfully!")

      # Verify booking was created in database
      booking = Booking.last
      expect(booking).to be_present
      expect(booking.item).to eq(item)
      expect(booking.renter).to eq(renter)
      expect(booking.owner).to eq(owner)
      expect(booking.status).to eq("requested")
      expect(booking.start_date).to eq(Date.parse("2025-03-21"))
      expect(booking.end_date).to eq(Date.parse("2025-06-21"))
    end
  end

  describe "PATCH /bookings/:id/approve" do
    it "updates booking status from requested to approved" do
      # Setup: create users, item, and a requested booking
      renter = User.create!(username: "isabelle", role: "renter", email: "isabelle@example.com", password: "password")
      owner = User.create!(username: "erfu", role: "owner", email: "erfu@example.com", password: "password")
      item = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "available", payment_methods: "credit_card", deposit_amount: 0)
      booking = Booking.create!(
        item: item,
        renter: renter,
        owner: owner,
        start_date: Date.parse("2025-03-21"),
        end_date: Date.parse("2025-06-21"),
        status: :requested
      )

      # Verify initial status
      expect(booking.status).to eq("requested")

      # Sign in as owner to approve
      sign_in owner

      # Make the PATCH request to approve
      patch "/bookings/#{booking.id}/approve"

      # Verify response - should redirect after successful approval
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(bookings_path)
      follow_redirect!
      expect(response.body).to include("Booking approved successfully!")

      # Verify booking status was updated in database
      booking.reload
      expect(booking.status).to eq("approved")
    end
  end
end
