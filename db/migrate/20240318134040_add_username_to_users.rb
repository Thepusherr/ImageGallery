class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    execute "UPDATE users SET username = name||' '||surname WHERE username IS NULL;"
  end
end
