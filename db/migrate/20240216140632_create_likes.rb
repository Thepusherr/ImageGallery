class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.integer :post_id
      t.boolean :active

      t.timestamps
    end
  end
end
