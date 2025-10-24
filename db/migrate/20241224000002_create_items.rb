class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price_per_day, precision: 10, scale: 2, null: false
      t.string :category
      t.string :availability, default: 'available'
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :items, :category
    add_index :items, :availability
    add_index :items, :price_per_day
  end
end