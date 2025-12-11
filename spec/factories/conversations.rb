FactoryBot.define do
  factory :conversation do
    booking
    # Ensure consistency: use the booking's associated users
    owner { booking.owner }
    renter { booking.renter }
  end
end
