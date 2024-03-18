class Category < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :users
end
