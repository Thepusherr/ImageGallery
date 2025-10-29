# frozen_string_literal: true

class AddUserToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :user_id, :string
  end
end
