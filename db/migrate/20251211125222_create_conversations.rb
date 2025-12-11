class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: {to_table: :users}
      t.references :renter, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
