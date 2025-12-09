class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles
  ROLES = %w[renter owner admin].freeze
  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z][a-zA-Z0-9_]*\z/ }, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/}
  validates :role, presence: true, inclusion: { in: ROLES }

  unless Rails.env.test?
    validates :security_question_1, :security_question_2,
              :security_answer_1, :security_answer_2,
              presence: true
  end


  # Associations
  has_many :items, foreign_key: :owner_id, dependent: :destroy
  has_many :bookings_as_renter, class_name: "Booking", foreign_key: :renter_id, dependent: :destroy
  has_many :bookings_as_owner, class_name: "Booking", foreign_key: :owner_id, dependent: :destroy
  has_many :disputes_created, class_name: "Dispute", foreign_key: :created_by_id, dependent: :destroy
  has_many :contacts, dependent: :destroy

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
