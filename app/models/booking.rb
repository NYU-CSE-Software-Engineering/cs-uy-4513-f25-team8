class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :renter, class_name: "User", optional: true
  belongs_to :owner, class_name: "User", optional: true

  enum :status, { requested: 0, approved: 1 }
  before_validation :set_default_status, on: :create

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validate :start_date_before_end_date
  validate :item_must_be_available, on: :create
  validate :cannot_approve_unavailable_item
  private
  def set_default_status
    self.status ||= :requested
  end
  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "must be before or equal to end date")
    end
  end
  def item_must_be_available
    if item.present? && item.availability_status != "available"
      errors.add(:item, "is not available for booking")
    end
  end

  def cannot_approve_unavailable_item
    if status == "approved" && item.present? && item.availability_status != "available"
      errors.add(:status, "cannot be approved if item is unavailable")
    end
  end
end