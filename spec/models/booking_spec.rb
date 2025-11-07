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
end