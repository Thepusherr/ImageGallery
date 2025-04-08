# Mock UserEvent for tests
class UserEvent < ApplicationRecord
  belongs_to :user
  
  def self.create!(attributes)
    # Return a mock object in tests
    OpenStruct.new(attributes)
  end
end