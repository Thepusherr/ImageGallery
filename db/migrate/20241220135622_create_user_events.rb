class CreateUserEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :user_events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action_type
      t.string :url
      t.datetime :timestamp

      t.timestamps
    end
  end
end
