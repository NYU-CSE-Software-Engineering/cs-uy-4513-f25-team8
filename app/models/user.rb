class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Associations
  has_many :items, foreign_key: :owner_id, dependent: :destroy
  has_many :bookings, foreign_key: :renter_id, dependent: :destroy
  has_many :owner_bookings, class_name: 'Booking', foreign_key: :owner_id, dependent: :destroy
  has_many :payments_sent, class_name: 'Payment', foreign_key: :payer_id
  has_many :payments_received, class_name: 'Payment', foreign_key: :payee_id

  # Validations
  validates :role, inclusion: { in: %w[owner renter admin] }, allow_blank: true

  # Scopes
  scope :owners, -> { where(role: 'owner') }
  scope :renters, -> { where(role: 'renter') }
  scope :admins, -> { where(role: 'admin') }

  # Instance methods
  def owner?
    role == 'owner'
  end

  def renter?
    role == 'renter'
  end

  def admin?
    role == 'admin'
  end
end