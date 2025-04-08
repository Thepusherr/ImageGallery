class AddVisibilityToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :visibility, :integer, default: 0, null: false
  end
end
