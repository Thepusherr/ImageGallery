class AddColumnToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :user_id, :integer
    change_column_null :comments, :user_id, false
  end
end
