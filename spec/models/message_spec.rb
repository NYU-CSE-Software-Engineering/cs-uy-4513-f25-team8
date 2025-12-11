require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:sender) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }

    describe 'participant validation' do
      let(:conversation) { create(:conversation) }
      let(:outsider) { create(:user) }

      it 'allows the owner to send messages' do
        message = build(:message, conversation:, sender: conversation.owner)
        expect(message).to be_valid
      end

      it 'allows the renter to send messages' do
        message = build(:message, conversation:, sender: conversation.renter)
        expect(message).to be_valid
      end

      it 'disallows non-participants' do
        message = build(:message, conversation:, sender: outsider)

        expect(message).not_to be_valid
        expect(message.errors[:sender]).to include("must be a participant in the conversation")
      end
    end
  end
end
