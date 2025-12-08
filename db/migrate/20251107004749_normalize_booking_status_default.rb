class NormalizeBookingStatusDefault < ActiveRecord::Migration[8.1]
  def up
    change_column_default :bookings, :status, from: nil, to: 0
    change_column_null :bookings, :status, false, 0
  end

  def down
    change_column_null :bookings, :status, true
    change_column_default :bookings, :status, from: 0, to: nil
  end
end
