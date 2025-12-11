# spec/models/conversation_spec.rb
require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'associations' do
    it { should belong_to(:booking) }
    it { should belong_to(:owner) }
    it { should belong_to(:renter) }
  end

  describe 'validations' do
    # In Rails 5+ belongs_to implies presence by default,
    # but it’s still nice to have explicit specs.
    it { should validate_presence_of(:booking) }
    it { should validate_presence_of(:owner) }
    it { should validate_presence_of(:renter) }

    describe 'owner and renter must be different' do
      let(:user) { create(:user) }
      let(:booking) { create(:booking) }

      it 'is invalid when owner and renter are the same user' do
        conversation = build(
          :conversation,
          booking: booking,
          owner: user,
          renter: user
        )

        expect(conversation).not_to be_valid
        expect(conversation.errors[:renter]).to include('must be different from owner')
      end

      it 'is valid when owner and renter are different users' do
        owner  = create(:user)
        renter = create(:user)

        conversation = build(
          :conversation,
          booking: booking,
          owner: owner,
          renter: renter
        )

        expect(conversation).to be_valid
      end
    end

    describe 'uniqueness per booking/participants' do
      subject { create(:conversation) }

      it do
        should validate_uniqueness_of(:booking_id)
          .scoped_to(:owner_id, :renter_id)
      end
    end
  end
end

