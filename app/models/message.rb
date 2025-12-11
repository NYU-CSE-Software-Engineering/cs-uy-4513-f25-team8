class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :body, presence: true
  validate :sender_must_be_participant

  private

  def sender_must_be_participant
    return if conversation.nil?

    unless [conversation.owner, conversation.renter].include?(sender)
      errors.add(:sender, "must be a participant in the conversation")
    end
  end
end
