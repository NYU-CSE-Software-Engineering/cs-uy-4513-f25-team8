class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :item, null: false, foreign_key: true
      t.references :renter, null: false,  foreign_key: { to_table: :users }
      t.references :owner, null: false,  foreign_key: { to_table: :users }
      t.date :start_date
      t.date :end_date
      t.string :status

      t.timestamps
    end
  end
end
