class Payment < ApplicationRecord
  # Associations
  belongs_to :booking
  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :payee, class_name: 'User', foreign_key: 'payee_id'

  # Validations
  validates :dollar_amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_type, inclusion: { in: %w[deposit rental adjustment refund] }
  validates :status, inclusion: { in: %w[pending succeeded failed] }

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :succeeded, -> { where(status: 'succeeded') }
  scope :failed, -> { where(status: 'failed') }
  scope :deposits, -> { where(payment_type: 'deposit') }
  scope :rentals, -> { where(payment_type: 'rental') }
  scope :refunds, -> { where(payment_type: 'refund') }

  # Instance methods
  def process!
    # Simulate payment processing
    update!(
      status: 'succeeded',
      reference_code: generate_reference_code,
      settled_at: Time.current
    )
  end

  def fail!
    update!(status: 'failed')
  end

  def pending?
    status == 'pending'
  end

  def succeeded?
    status == 'succeeded'
  end

  def failed?
    status == 'failed'
  end

  private

  def generate_reference_code
    "PAY-#{SecureRandom.hex(8).upcase}"
  end
end