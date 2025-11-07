require 'rails_helper'

RSpec.describe Item, type: :model do
    it "requires title" do
    i = Item.new(title: nil)
    expect(i).not_to be_valid
    expect(i.errors[:title]).to be_present
  end
end