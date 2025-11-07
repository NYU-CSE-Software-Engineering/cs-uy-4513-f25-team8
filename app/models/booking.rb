class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :renter, class_name: "User", optional: true
  belongs_to :owner, class_name: "User", optional: true
  enum :status, { requested: 0, approved: 1 }
  before_validation :set_default_status, on: :create
  validate :start_date_before_end_date
  private
  def set_default_status
    self.status = :requested if status.blank?
  end
  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "must be before or equal to end date")
    end
  end
end
