require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'associations' do
    it 'belongs to a booking, owner, and renter' do
      booking = create(:booking)
      owner   = create(:user)
      renter  = create(:user)

      conversation = Conversation.create(
        booking: booking,
        owner: owner,
        renter: renter
      )

      expect(conversation.booking).to eq(booking)
      expect(conversation.owner).to eq(owner)
      expect(conversation.renter).to eq(renter)
    end
  end

  describe 'validations' do
    it 'is invalid without a booking' do
      conversation = Conversation.new(
        booking: nil,
        owner: create(:user),
        renter: create(:user)
      )

      expect(conversation).not_to be_valid
      expect(conversation.errors[:booking]).to be_present
    end

    it 'is invalid without an owner' do
      conversation = Conversation.new(
        booking: create(:booking),
        owner: nil,
        renter: create(:user)
      )

      expect(conversation).not_to be_valid
      expect(conversation.errors[:owner]).to be_present
    end

    it 'is invalid without a renter' do
      conversation = Conversation.new(
        booking: create(:booking),
        owner: create(:user),
        renter: nil
      )

      expect(conversation).not_to be_valid
      expect(conversation.errors[:renter]).to be_present
    end

    describe 'owner and renter must be different' do
      let(:user)    { create(:user) }
      let(:booking) { create(:booking) }

      it 'is invalid when owner and renter are the same user' do
        conversation = Conversation.new(
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

        conversation = Conversation.new(
          booking: booking,
          owner: owner,
          renter: renter
        )

        expect(conversation).to be_valid
      end
    end

    describe 'uniqueness per booking/participants' do
      it 'does not allow duplicate conversations for the same booking/owner/renter' do
        booking = create(:booking)
        owner   = create(:user)
        renter  = create(:user)

        first = Conversation.create!(
          booking: booking,
          owner: owner,
          renter: renter
        )

        duplicate = Conversation.new(
          booking: booking,
          owner: owner,
          renter: renter
        )

        expect(duplicate).not_to be_valid
        # adjust key depending on your validation (booking vs booking_id)
        expect(duplicate.errors[:booking_id].presence || duplicate.errors[:booking]).to be_present
      end
    end
  end
end

