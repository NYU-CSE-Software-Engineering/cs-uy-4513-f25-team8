require 'rails_helper'

RSpec.describe User, type: :model do
    it "requires username" do
        u = User.new(username: nil)
        expect(u).not_to be_valid
        expect(u.errors[:username]).to be_present
    end
    it "requires role" do
        u = User.new(username: "lily", role: nil)
        expect(u).not_to be_valid
        expect(u.errors[:role]).to be_present
    end
    it "only allows role to be renter/owner/admin" do
        u = User.new(username: "lily", role: "badrole")
        expect(u).not_to be_valid
        expect(u.errors[:role]).to be_present
    end
    it "defaults account_status to 'active'" do
        u = User.create!(username: "jane", role: "renter", email: "jane@example.com", password: "password123")
        expect(u.account_status).to eq("active")
    end
    it "defaults report_count to 0" do
        u = User.create!(username: "erfu", role: "owner", email: "erfu@example.com", password: "password123")
        expect(u.report_count).to eq(0)
    end
    it "requires email" do
      u = User.new(username: "lily", role: "renter", email: nil)
      expect(u).not_to be_valid
      expect(u.errors[:email]).to be_present
    end
    it "is invalid if the email is not unique" do
      User.create!(username: "first", role: "renter", email: "duplicate@example.com", password: "password123")
      duplicate = User.new(username: "second", role: "owner", email: "duplicate@example.com")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to be_present
    end
    it "is invalid without a password" do
      u = User.new(username: "lily", role: "renter", email: "lily@example.com", password: nil)
      expect(u).not_to be_valid
      expect(u.errors[:password]).to be_present
    end
    it "can have many items if the user is an owner" do
      owner = User.create!(
        username: "erfu",
        role: "owner",
        email: "erfu@example.com",
        password: "password123"
      )

      item1 = Item.create!(title: "Camera", price: 25.0, owner: owner)
      item2 = Item.create!(title: "Tripod", price: 15.0, owner: owner)

      expect(owner.items).to include(item1, item2)
    end
    it "can have many bookings as a renter" do
      renter = User.create!(
        username: "isabelle",
        role: "renter",
        email: "isa@example.com",
        password: "password123"
      )
      owner = User.create!(
        username: "erfu",
        role: "owner",
        email: "erfu@example.com",
        password: "password123"
      )
      item = Item.create!(title: "Camera", price: 25.0, owner: owner)

      booking1 = Booking.create!(
        item: item,
        renter: renter,
        owner: owner,
        start_date: Date.today,
        end_date: Date.tomorrow
      )

      booking2 = Booking.create!(
        item: item,
        renter: renter,
        owner: owner,
        start_date: Date.today + 2,
        end_date: Date.today + 3
      )

      expect(renter.bookings_as_renter).to include(booking1, booking2)
    end
    it "can have many bookings as an owner" do
      owner = User.create!(
        username: "erfu",
        role: "owner",
        email: "erfu@example.com",
        password: "password123"
      )
      renter = User.create!(
        username: "isabelle",
        role: "renter",
        email: "isa@example.com",
        password: "password123"
      )
      item = Item.create!(title: "Camera", price: 25.0, owner: owner)

      booking1 = Booking.create!(
        item: item,
        renter: renter,
        owner: owner,
        start_date: Date.today,
        end_date: Date.tomorrow
      )

      booking2 = Booking.create!(
        item: item,
        renter: renter,
        owner: owner,
        start_date: Date.today + 2,
        end_date: Date.today + 3
      )

      expect(owner.bookings_as_owner).to include(booking1, booking2)
    end

end

