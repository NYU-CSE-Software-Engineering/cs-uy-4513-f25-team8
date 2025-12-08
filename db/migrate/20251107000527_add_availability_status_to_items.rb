class AddAvailabilityStatusToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :availability_status, :string, default: "available", null: false
  end
end
