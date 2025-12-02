class AddFieldsToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :description, :text
    add_column :items, :category, :string
  end
end
