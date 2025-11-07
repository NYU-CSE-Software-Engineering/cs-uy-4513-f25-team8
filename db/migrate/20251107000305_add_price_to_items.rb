class AddPriceToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :price, :decimal, precision: 10, scale: 2, null: false
  end
end
