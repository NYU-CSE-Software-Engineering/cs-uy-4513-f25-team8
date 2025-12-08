require 'rails_helper'

RSpec.describe User, type: :model do
  describe "disabled account functionality" do
    let(:user) { create(:user, :renter, account_status: "active") }

    it "prevents disabled users from authenticating" do
      user.update(account_status: "disabled")
      expect(user.active_for_authentication?).to be false
    end

    it "allows active users to authenticate" do
      expect(user.active_for_authentication?).to be true
    end

    it "returns account_disabled message for disabled users" do
      user.update(account_status: "disabled")
      expect(user.inactive_message).to eq(:account_disabled)
    end
  end
end

