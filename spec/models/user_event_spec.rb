require 'rails_helper'

RSpec.describe UserEvent, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    user_event = FactoryBot.build(:user_event, user: user)
    expect(user_event).to be_valid
  end

  it 'is not valid without a user' do
    user = FactoryBot.create(:user)
    user_event = FactoryBot.build(:user_event, user: nil)
    expect(user_event).to_not be_valid
  end

  it 'is not valid without an action_type' do
    user = FactoryBot.create(:user)
    user_event = FactoryBot.build(:user_event, action_type: nil, user: user)
    expect(user_event).to_not be_valid
  end
end
