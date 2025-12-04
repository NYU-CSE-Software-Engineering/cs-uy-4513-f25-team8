class Payment < ApplicationRecord
  belongs_to :booking
  belongs_to :payer, class_name: "User"
  belongs_to :payee, class_name: "User"

  VALID_PAYMENT_TYPES = %w[deposit rental adjustment refund].freeze
  VALID_STATUSES      = %w[pending succeeded failed refunded].freeze

  # Basic presence validations
  validates :booking, :payer, :payee, presence: true

  validates :payment_type,
            presence: true,
            inclusion: { in: VALID_PAYMENT_TYPES }

  validates :status,
            presence: true,
            inclusion: { in: VALID_STATUSES }

  validates :dollar_amount,
            presence: true,
            numericality: { greater_than: 0 }

  # On succeeded payments, we must have reference_code and settled_at
  validates :reference_code, :settled_at,
            presence: true,
            if: -> { status == "succeeded" }

  # Default method should be "simulated"
  before_validation :set_default_payment_method

  private

  def set_default_payment_method
    self.payment_method ||= "simulated"
  end
end
