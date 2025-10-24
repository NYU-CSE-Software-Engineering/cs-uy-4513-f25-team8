class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :item, null: false, foreign_key: true
      t.references :renter, null: false, foreign_key: { to_table: :users }
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :status, default: 'pending'
      t.boolean :deposit_required, default: false
      t.decimal :deposit_amount, precision: 10, scale: 2

      t.timestamps
    end

    add_index :bookings, :status
    add_index :bookings, :start_date
    add_index :bookings, :end_date
  end
end