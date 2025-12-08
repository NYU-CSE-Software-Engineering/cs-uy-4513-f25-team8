class Item < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_one_attached :image
    has_many :disputes, dependent: :destroy
    has_many :bookings, dependent: :destroy

    validates :title, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10000 }
    validates :payment_methods, presence: true, inclusion: { in: %w[credit_card cash both] }
    validates :deposit_amount, numericality: { greater_than_or_equal_to: 0 }
    attribute :availability_status, :string, default: "available"
    attribute :payment_methods, :string, default: "credit_card"
    attribute :deposit_amount, :decimal, default: 0.0

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
        return filter_by_availability if start_date.blank? || end_date.blank?
        filter_by_availability.where(
            "(available_from IS NULL OR available_from <= ?) AND (available_to IS NULL OR available_to >= ?)",
            Date.parse(end_date),
            Date.parse(start_date)
        )
    }

    # Update availability dates based on approved bookings
    # This method adjusts available_from and available_to to exclude approved booking dates
    # Note: For bookings in the middle of the period, we can't represent split ranges,
    # but the available_for_dates? method prevents overlapping bookings
    def update_availability_dates
      approved_bookings = bookings.where(status: :approved)
                                   .where.not(start_date: nil, end_date: nil)
                                   .order(:start_date)
      
      return if approved_bookings.empty?
      
      # If no availability dates are set, we can't update them
      return if available_from.nil? && available_to.nil?

      # Get all booked date ranges
      booked_ranges = approved_bookings.map { |b| [b.start_date, b.end_date] }
      
      # Find the earliest booking start and latest booking end
      earliest_booking_start = booked_ranges.map(&:first).min
      latest_booking_end = booked_ranges.map(&:last).max

      new_available_from = available_from
      new_available_to = available_to

      # Handle bookings that start at or before available_from
      if available_from.present? && earliest_booking_start <= available_from
        # Find the latest end date of bookings that start at or before available_from
        bookings_at_start = booked_ranges.select { |s, e| s <= available_from }
        if bookings_at_start.any?
          latest_end_at_start = bookings_at_start.map(&:last).max
          # Update available_from to the day after the latest booking ends
          if latest_end_at_start && (available_to.nil? || latest_end_at_start < available_to)
            new_available_from = latest_end_at_start + 1.day
          end
        end
      end

      # Handle bookings that end at or after available_to
      if available_to.present? && latest_booking_end >= available_to
        # Find the earliest start date of bookings that end at or after available_to
        bookings_at_end = booked_ranges.select { |s, e| e >= available_to }
        if bookings_at_end.any?
          earliest_start_at_end = bookings_at_end.map(&:first).min
          # Update available_to to the day before the earliest booking starts
          if earliest_start_at_end && (available_from.nil? || earliest_start_at_end > available_from)
            new_available_to = earliest_start_at_end - 1.day
          end
        end
      end

      # Check if all dates are booked (available_from > available_to)
      if new_available_from.present? && new_available_to.present? && new_available_from > new_available_to
        # All dates in the original range are booked
        update_columns(
          available_from: nil,
          available_to: nil,
          availability_status: "unavailable"
        )
      elsif new_available_from != available_from || new_available_to != available_to
        # Update the availability dates
        update_columns(
          available_from: new_available_from,
          available_to: new_available_to
        )
      end
    end

    # Check if item is available for a specific date range (excluding approved bookings)
    def available_for_dates?(requested_start, requested_end)
      return false unless availability_status == "available"
      return false if available_from.present? && requested_start < available_from
      return false if available_to.present? && requested_end > available_to

      # Check for overlapping approved bookings
      overlapping_bookings = bookings.where(status: :approved)
                                     .where("start_date <= ? AND end_date >= ?", requested_end, requested_start)
      
      overlapping_bookings.empty?
    end
end
