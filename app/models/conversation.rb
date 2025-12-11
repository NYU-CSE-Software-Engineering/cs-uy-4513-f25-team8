class Conversation < ApplicationRecord
  belongs_to :booking
  belongs_to :owner
  belongs_to :renter
end
