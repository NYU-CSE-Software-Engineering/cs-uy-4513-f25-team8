class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles
  ROLES = %w[renter owner admin].freeze
  validates :username, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }

  # Associations
  has_many :items, foreign_key: :owner_id, dependent: :destroy
  has_many :bookings_as_renter, class_name: "Booking", foreign_key: :renter_id, dependent: :destroy
  has_many :bookings_as_owner, class_name: "Booking", foreign_key: :owner_id, dependent: :destroy

  # Defaults
  attribute :account_status, :string, default: "active"
  attribute :report_count, :integer, default: 0
end
