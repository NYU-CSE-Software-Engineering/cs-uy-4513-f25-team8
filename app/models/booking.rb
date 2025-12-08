class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :renter, class_name: "User", optional: true
  belongs_to :owner, class_name: "User", optional: true
  
  has_many :payments, dependent: :destroy   # ← added for payment

  enum :status, { requested: 0, approved: 1, declined: 2 }
  before_validation :set_default_status, on: :create
  after_commit :update_item_availability, on: :update, if: :saved_change_to_status?

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
      return
    end
    
    # Check if the requested dates are available (not overlapping with approved bookings)
    if item.present? && start_date.present? && end_date.present?
      unless item.available_for_dates?(start_date, end_date)
        errors.add(:base, "The item is not available for the selected dates. Please choose different dates.")
      end
    end
  end

  def cannot_approve_unavailable_item
    if status == "approved" && item.present? && item.availability_status != "available"
      errors.add(:status, "cannot be approved if item is unavailable")
    end
  end

  def update_item_availability
    return unless status == "approved" && start_date.present? && end_date.present?
    
    item.update_availability_dates
  end
end
