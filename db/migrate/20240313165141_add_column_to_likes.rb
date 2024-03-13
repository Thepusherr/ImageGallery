class AddColumnToLikes < ActiveRecord::Migration[7.1]
  def change
    add_column :likes, :post_id, :integer, null: false, default: 0
    change_column :likes, :post_id, :integer, default: nil
  end
end
