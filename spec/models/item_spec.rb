require 'rails_helper'

RSpec.describe Item, type: :model do
    let!(:owner) { User.create!(username: "erfu", role: "owner", email: "erfu@example.com", password: "password123") }
    it "requires title" do
        i = Item.new(title: nil, owner: owner)
        expect(i).not_to be_valid
        expect(i.errors[:title]).to be_present
    end
    it "requires a positive price" do
        i1 = Item.new(title: "Camera", price: nil, owner: owner)
        expect(i1).not_to be_valid
        expect(i1.errors[:price]).to be_present

        i2 = Item.new(title: "Camera", price: -10, owner: owner)
        expect(i2).not_to be_valid
        expect(i2.errors[:price]).to be_present

    end
    it "defaults availability_status to 'available'" do
        i = Item.create!(title: "Tripod", price: 25.00, owner: owner)
        expect(i.availability_status).to eq("available")
    end
    it "belongs to an owner (User)" do
        item  = Item.create!(title: "Camera", price: 25.0, owner: owner)
        expect(item.owner).to eq(owner)
    end
end