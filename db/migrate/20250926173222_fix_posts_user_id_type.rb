class FixPostsUserIdType < ActiveRecord::Migration[7.1]
  def up
    # First, let's check if there are any invalid user_ids
    execute "UPDATE posts SET user_id = '1' WHERE user_id IS NULL OR user_id = '' OR user_id NOT IN (SELECT id::text FROM users)"

    # Change the column type from string to bigint
    change_column :posts, :user_id, :bigint, using: 'user_id::bigint'

    # Add foreign key constraint
    add_foreign_key :posts, :users, column: :user_id
  end

  def down
    # Remove foreign key constraint
    remove_foreign_key :posts, :users

    # Change back to string
    change_column :posts, :user_id, :string
  end
end
