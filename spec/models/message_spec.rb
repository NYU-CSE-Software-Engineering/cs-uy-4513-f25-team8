require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it 'belongs to a conversation and a sender' do
      conversation = create(:conversation)
      sender       = create(:user)

      message = Message.create(
        conversation: conversation,
        sender: sender,
        body: 'hello'
      )

      expect(message.conversation).to eq(conversation)
      expect(message.sender).to eq(sender)
    end
  end

  describe 'validations' do
    it 'is invalid without a body' do
      message = Message.new(
        conversation: create(:conversation),
        sender: create(:user),
        body: nil
      )

      expect(message).not_to be_valid
      expect(message.errors[:body]).to be_present
    end

    describe 'participant validation' do
      let(:conversation) { create(:conversation) }
      let(:outsider)     { create(:user) }

      it 'allows the owner to send messages' do
        message = Message.new(
          conversation: conversation,
          sender: conversation.owner,
          body: 'hi from owner'
        )

        expect(message).to be_valid
      end

      it 'allows the renter to send messages' do
        message = Message.new(
          conversation: conversation,
          sender: conversation.renter,
          body: 'hi from renter'
        )

        expect(message).to be_valid
      end

      it 'disallows non-participants' do
        message = Message.new(
          conversation: conversation,
          sender: outsider,
          body: 'i should not be allowed'
        )

        expect(message).not_to be_valid
        expect(message.errors[:sender]).to include('must be a participant in the conversation')
      end
    end
  end
end

