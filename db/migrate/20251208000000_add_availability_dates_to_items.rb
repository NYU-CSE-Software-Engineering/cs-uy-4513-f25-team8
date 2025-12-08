class AddAvailabilityDatesToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :available_from, :date
    add_column :items, :available_to, :date
  end
end

