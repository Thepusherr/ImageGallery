class AddIndexToUsersNameAndSurname < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :name
    add_index :users, :surname
  end
end
