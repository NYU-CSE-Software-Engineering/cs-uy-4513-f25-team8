# spec/requests/bookings_spec.rb
require "rails_helper"

RSpec.describe "Bookings", type: :request do
  describe "POST /bookings" do
    it "creates a booking with status requested and shows success message" do
      # Setup: create users and item
      renter = User.create!(username: "isabelle", role: "renter")
      owner = User.create!(username: "erfu", role: "owner")
      item = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "available")

      # Make the POST request
      post "/bookings", params: {
        item_id: item.id,
        renter_id: renter.id,
        owner_id: owner.id,
        start_date: "2025-03-21",
        end_date: "2025-06-21"
      }

      # Verify response
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Booking request submitted")

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
      renter = User.create!(username: "isabelle", role: "renter")
      owner = User.create!(username: "erfu", role: "owner")
      item = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "available")
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

      # Make the PATCH request to approve
      patch "/bookings/#{booking.id}/approve"

      # Verify response
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Booking approved")

      # Verify booking status was updated in database
      booking.reload
      expect(booking.status).to eq("approved")
    end
  end
end
