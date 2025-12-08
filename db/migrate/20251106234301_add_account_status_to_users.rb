class AddAccountStatusToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :account_status, :string, default: "active", null: false
  end
end
