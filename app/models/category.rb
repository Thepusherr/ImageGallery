class Category < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :user

  has_many :users
  has_many :posts
end
