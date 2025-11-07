class User < ApplicationRecord
  has_secure_password
  ROLES = %w[renter owner admin].freeze
    validates :username, presence: true
    validates :role, presence: true, inclusion: { in: ROLES }
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
    has_many :items, foreign_key: :owner_id, dependent: :destroy

  attribute :account_status, :string, default: "active"
end