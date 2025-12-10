class Dispute < ApplicationRecord
  belongs_to :booking, optional: true
  belongs_to :item, optional: true
  belongs_to :created_by, class_name: "User"
  belongs_to :resolved_by, class_name: "User", optional: true

  validates :status, presence: true, inclusion: { in: %w[open resolved] }
  validates :item, presence: true
  validates :reason, presence: true
  validates :details, presence: true
  validates :item_id, uniqueness: { scope: :created_by_id, message: "has already been reported by you" }

  scope :open, -> { where(status: 'open') }
  scope :resolved, -> { where(status: 'resolved') }

  def resolve!(admin_user, notes = nil)
    update!(
      status: 'resolved',
      resolved_by: admin_user,
      resolved_at: Time.current,
      resolution_notes: notes
    )
  end
end

