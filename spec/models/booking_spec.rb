require "rails_helper"

RSpec.describe Booking, type: :model do
    it "requires item" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu",     role: "owner")
        # no item on purpose
        b = Booking.new(
        item: nil,
        renter: renter,
        owner: owner,
        start_date: Date.new(2025, 3, 21),
        end_date:   Date.new(2025, 6, 21)
        )
        expect(b).not_to be_valid
        expect(b.errors[:item]).to be_present
    end
    it "belongs to a renter (User)" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu", role: "owner")
        item   = Item.create!(title: "Camera", price: 25.0, owner: owner)

        b = Booking.create!(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 3, 21),
            end_date: Date.new(2025, 3, 22)
        )

        expect(b.renter).to eq(renter)
        expect(b.renter).to be_a(User)
    end
    it "has a status enum that includes at least 'requested' and 'approved'" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu",     role: "owner")
        item   = Item.create!(title: "Camera", price: 25.0, owner: owner)

        b = Booking.new(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 3, 21),
            end_date: Date.new(2025, 3, 22)
        )

        expect(Booking.defined_enums["status"].keys).to include("requested", "approved")
        b.status = :requested
        expect(b).to be_valid

        b.status = :approved
        expect(b).to be_valid
    end
    it "is invalid if start_date is after end_date" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu", role: "owner")
        item   = Item.create!(title: "Camera", price: 25.0, owner: owner)

        booking = Booking.new(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 6, 21),
            end_date: Date.new(2025, 3, 21)
        )

        expect(booking).not_to be_valid
        expect(booking.errors[:start_date]).to be_present
    end
    it "cannot be created or approved if the item is not available" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu", role: "owner")
        item   = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "unavailable")
        booking = Booking.new(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 3, 21),
            end_date: Date.new(2025, 3, 22),
            status: :requested
        )

        expect(booking).not_to be_valid
        expect(booking.errors[:item]).to be_present
        item.update!(availability_status: "available")
        booking = Booking.create!(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 3, 21),
            end_date: Date.new(2025, 3, 22)
        )
        item.update!(availability_status: "unavailable")

        booking.status = :approved
        expect(booking.valid?).to be false
        expect(booking.errors[:status]).to include("cannot be approved if item is unavailable")
    end
    it "transitions from requested -> approved when item is available" do
        renter = User.create!(username: "isabelle", role: "renter")
        owner  = User.create!(username: "erfu",     role: "owner")
        item   = Item.create!(title: "Camera", price: 25.0, owner: owner, availability_status: "available")

        booking = Booking.create!(
            item: item,
            renter: renter,
            owner: owner,
            start_date: Date.new(2025, 3, 21),
            end_date: Date.new(2025, 3, 22)
        )

        expect(booking).to be_requested

        booking.update!(status: :approved)
        booking.reload
        expect(booking).to be_approved
    end
end