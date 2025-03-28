require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    category = Category.new(name: 'Test Category', user: user)
    expect(category).to be_valid
  end

  it 'is not valid without a name' do
    user = FactoryBot.create(:user)
    category = Category.new(name: nil, user: user)
    expect(category).to_not be_valid
  end

  it 'is not valid without a user' do
    user = FactoryBot.create(:user)
    category = Category.new(name: 'Test Category', user: nil)
    expect(category).to_not be_valid
  end

  # it 'is not valid with a duplicate name' do
  #   user = FactoryBot.create(:user)
  #   Category.create(name: 'Test Category', user: user)
  #   category = Category.new(name: 'Test Category', user: user)
  #   expect(category).to_not be_valid
  # end
end
