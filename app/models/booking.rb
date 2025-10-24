class Booking < ApplicationRecord
  # Associations
  belongs_to :item
  belongs_to :renter, class_name: 'User', foreign_key: 'renter_id'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :payments, dependent: :destroy

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected cancelled completed] }
  validate :end_date_after_start_date

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :completed, -> { where(status: 'completed') }

  # Instance methods
  def total_days
    (end_date - start_date).to_i + 1
  end

  def total_price
    item.price_per_day * total_days
  end

  def approve!
    update!(status: 'approved')
  end

  def reject!
    update!(status: 'rejected')
  end

  def cancel!
    update!(status: 'cancelled')
  end

  def complete!
    update!(status: 'completed')
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end