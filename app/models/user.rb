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
  has_many :disputes_created, class_name: "Dispute", foreign_key: :created_by_id, dependent: :destroy

  # Defaults
  attribute :account_status, :string, default: "active"
  attribute :report_count, :integer, default: 0

  # Devise: prevent disabled users from logging in
  def active_for_authentication?
    super && account_status != 'disabled'
  end

  def inactive_message
    account_status == 'disabled' ? :account_disabled : super
  end
end
