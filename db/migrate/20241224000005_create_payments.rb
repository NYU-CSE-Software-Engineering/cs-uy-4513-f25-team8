class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :payer, null: false, foreign_key: { to_table: :users }
      t.references :payee, null: false, foreign_key: { to_table: :users }
      t.decimal :dollar_amount, precision: 10, scale: 2, null: false
      t.string :payment_type # deposit, rental, adjustment, refund
      t.string :method, default: 'simulated'
      t.string :status, default: 'pending' # pending, succeeded, failed
      t.string :reference_code
      t.datetime :settled_at

      t.timestamps
    end

    add_index :payments, :status
    add_index :payments, :payment_type
    add_index :payments, :reference_code
  end
end