class User < ApplicationRecord
  has_secure_password
  ROLES = %w[renter owner admin].freeze
  validates :username, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :email, presence: true, uniqueness: true
  has_many :items, foreign_key: :owner_id, dependent: :destroy
  has_many :bookings_as_renter, class_name: "Booking", foreign_key: :renter_id, dependent: :destroy
  has_many :bookings_as_owner, class_name: "Booking", foreign_key: :owner_id, dependent: :destroy
  attribute :account_status, :string, default: "active"
  attribute :report_count, :integer, default: 0
end