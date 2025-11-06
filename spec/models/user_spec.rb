require 'rails_helper'

RSpec.describe User, type: :model do
    it "requires username" do
    u = User.new(username: nil)
    expect(u).not_to be_valid
    expect(u.errors[:username]).to be_present
  end
end
