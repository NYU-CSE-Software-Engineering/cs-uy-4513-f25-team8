class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :payer,  null: false, foreign_key: { to_table: :users }
      t.references :payee,  null: false, foreign_key: { to_table: :users }

      t.decimal :dollar_amount, null: false, precision: 10, scale: 2

      # We’ll use simple strings instead of Rails enum
      t.string  :payment_type,   null: false   # "deposit", "rental", etc.
      t.string  :status,         null: false   # "pending", "succeeded", etc.
      t.string  :payment_method, null: false, default: "simulated"

      t.string   :reference_code
      t.datetime :settled_at

      t.timestamps
    end
  end
end
