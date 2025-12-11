class Conversation < ApplicationRecord
  belongs_to :booking
  belongs_to :owner,  class_name: "User"
  belongs_to :renter, class_name: "User"

  has_many :messages, dependent: :destroy

  validates :booking, :owner, :renter, presence: true
  validates :booking_id, uniqueness: { scope: [:owner_id, :renter_id] }
  validate :owner_and_renter_must_be_different

  private

  def owner_and_renter_must_be_different
    return if owner != renter

    errors.add(:renter, 'must be different from owner')
  end
end
