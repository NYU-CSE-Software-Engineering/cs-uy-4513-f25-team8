class ChangeBookingsStatusToInteger < ActiveRecord::Migration[8.1]
  def up
    add_column :bookings, :status_int, :integer, default: 0, null: false

    execute <<~SQL
      UPDATE bookings
      SET status_int =
        CASE status
          WHEN 'approved' THEN 1
          WHEN '1' THEN 1
          ELSE 0 
        END;
    SQL


    remove_column :bookings, :status
    rename_column :bookings, :status_int, :status
  end

  def down
    add_column :bookings, :status_str, :string, default: "0", null: false
    execute <<~SQL
      UPDATE bookings
      SET status_str =
        CASE status
          WHEN 1 THEN '1'
          ELSE '0'
        END;
    SQL
    remove_column :bookings, :status
    rename_column :bookings, :status_str, :status
  end
end
