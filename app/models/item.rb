class Item < ApplicationRecord
  # Associations
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :bookings, dependent: :destroy

  # Active Storage
  has_one_attached :image

  # Validations
  validates :title, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than: 0 }
  validates :availability, inclusion: { in: %w[available unavailable] }

  # Scopes
  scope :available, -> { where(availability: 'available') }
  scope :unavailable, -> { where(availability: 'unavailable') }
  scope :by_category, ->(category) { where(category: category) }

  # Instance methods
  def available?
    availability == 'available'
  end

  def make_available!
    update!(availability: 'available')
  end

  def make_unavailable!
    update!(availability: 'unavailable')
  end

  # Categories list
  CATEGORIES = [
    'Electronics',
    'Tools',
    'Sports & Outdoors',
    'Home & Garden',
    'Vehicles',
    'Clothing & Accessories',
    'Books & Media',
    'Party & Event',
    'Other'
  ].freeze

  def self.categories
    CATEGORIES
  end
end