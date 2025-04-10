class AddVisibilityToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :visibility, :integer
  end
end
