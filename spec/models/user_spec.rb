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
        u = User.create!(username: "jane", role: "renter")
        expect(u.account_status).to eq("active")
    end
end

