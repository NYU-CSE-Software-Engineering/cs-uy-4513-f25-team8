class AddDeclineReasonToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :decline_reason, :text
  end
end
