class AddIndexToPostsUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :posts, :user_id
  end
end
