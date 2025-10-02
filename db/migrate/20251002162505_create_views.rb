class CreateViews < ActiveRecord::Migration[7.1]
  def change
    create_table :views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.datetime :viewed_at

      t.timestamps
    end

    # Ensure one view per user per post
    add_index :views, [:user_id, :post_id], unique: true
  end
end
