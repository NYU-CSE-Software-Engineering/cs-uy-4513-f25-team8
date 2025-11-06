class User < ApplicationRecord
    ROLES = %w[renter owner admin].freeze
    validates :username, presence: true
    validates :role, presence: true, inclusion: { in: ROLES }
    attribute :account_status, :string, default: "active"
end