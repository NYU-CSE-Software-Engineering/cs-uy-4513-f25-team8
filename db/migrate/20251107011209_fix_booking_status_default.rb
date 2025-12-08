class FixBookingStatusDefault < ActiveRecord::Migration[8.1]
  def change
     change_column_default :bookings, :status, from: "0", to: 0
  end
end
