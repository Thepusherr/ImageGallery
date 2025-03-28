require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    post = FactoryBot.build(:post, user: user)
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    user = FactoryBot.create(:user)
    post = FactoryBot.build(:post, title: nil, user: user)
    expect(post).to_not be_valid
  end

  it 'is not valid without content' do
    user = FactoryBot.create(:user)
    post = FactoryBot.build(:post, text: nil, user: user)
    expect(post).to_not be_valid
  end

  it 'is not valid without a user' do
    post = FactoryBot.build(:post, user: nil)
    expect(post).to_not be_valid
  end
end
