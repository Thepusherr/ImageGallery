# frozen_string_literal: true

class AddImageToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :image, :string
  end
end
