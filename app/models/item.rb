class Item < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_one_attached :image

    validates :title, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    attribute :availability_status, :string, default: "available"

    # Search scopes
    scope :search_by_keyword, ->(keyword) {
        return all if keyword.blank?
        where("title LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
    }

    scope :filter_by_category, ->(category) {
        return all if category.blank?
        where(category: category)
    }

    scope :filter_by_availability, -> {
        where(availability_status: "available")
    }

    scope :available_between, ->(start_date, end_date) {
        filter_by_availability
    }
end
