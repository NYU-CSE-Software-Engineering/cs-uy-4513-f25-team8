class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :renter, class_name: "User", optional: true
  belongs_to :owner, class_name: "User", optional: true
end
