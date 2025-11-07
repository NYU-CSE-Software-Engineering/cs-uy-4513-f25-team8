class Item < ApplicationRecord
    belongs_to :owner, class_name: "User"
    validates :title, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    attribute :availability_status, :string, default: "available"
end
