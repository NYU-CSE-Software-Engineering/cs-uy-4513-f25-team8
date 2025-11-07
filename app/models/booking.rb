class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :renter, class_name: "User", optional: true
  belongs_to :owner, class_name: "User", optional: true
  enum :status, { requested: 0, approved: 1 }
  before_validation :set_default_status, on: :create
  private
  def set_default_status
    self.status = :requested if status.blank?
  end
end
