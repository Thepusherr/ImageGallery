class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string, type: :string, as: "name + ' ' + surname", stored: true
    add_column :users, :username, :string
    execute "UPDATE users SET username = first_name||' '||last_name WHERE full_name IS NULL;"
  end
end
