class AddUniqueIndexToUsernameOnUsers < ActiveRecord::Migration[8.1]
  def up
    # First, handle any duplicate usernames by making them unique
    # This will append a number to duplicate usernames
    execute <<-SQL
      UPDATE users
      SET username = username || '_' || id
      WHERE id NOT IN (
        SELECT MIN(id)
        FROM users
        GROUP BY LOWER(username)
      )
      AND username IS NOT NULL;
    SQL
    
    # Now add the unique index
    add_index :users, :username, unique: true, name: "index_users_on_username"
  end

  def down
    remove_index :users, name: "index_users_on_username"
  end
end
