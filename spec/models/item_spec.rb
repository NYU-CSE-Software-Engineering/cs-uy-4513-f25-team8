require 'rails_helper'

RSpec.describe Item, type: :model do
    it "requires title" do
        i = Item.new(title: nil)
        expect(i).not_to be_valid
        expect(i.errors[:title]).to be_present
    end
    it "requires a positive price" do
        i = Item.new(title: "Camera", price: nil)
        expect(i).not_to be_valid
        expect(i.errors[:price]).to be_present

        i.price = -5
        expect(i).not_to be_valid
        expect(i.errors[:price]).to be_present
    end
    it "defaults availability_status to 'available'" do
        i = Item.create!(title: "Tripod", price: 25.00)
        expect(i.availability_status).to eq("available")
    end
    it "belongs to an owner (User)" do
        owner = User.create!(username: "owner1", role: "owner")
        item  = Item.create!(title: "Camera", price: 25.0, owner: owner)
        expect(item.owner).to eq(owner)
    end
end