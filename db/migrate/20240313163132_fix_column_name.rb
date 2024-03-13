class FixColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :likes, :post_id, :user_id
  end
end
