class CreateDisputes < ActiveRecord::Migration[8.1]
  def change
    create_table :disputes do |t|
      t.references :booking, null: true, foreign_key: true
      t.references :item, null: true, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :reason
      t.text :details
      t.string :status, default: 'open'
      t.references :resolved_by, null: true, foreign_key: { to_table: :users }
      t.datetime :resolved_at
      t.text :resolution_notes

      t.timestamps
    end
  end
end

