require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  it 'is valid with valid attributes' do
    admin_user = AdminUser.new(email: 'admin@example.com', password: 'password')
    expect(admin_user).to be_valid
  end

  it 'is not valid without an email' do
    admin_user = AdminUser.new(email: nil, password: 'password')
    expect(admin_user).to_not be_valid
  end

  it 'is not valid without a password' do
    admin_user = AdminUser.new(email: 'admin@example.com', password: nil)
    expect(admin_user).to_not be_valid
  end
end
