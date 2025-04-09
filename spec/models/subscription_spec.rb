require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    
    it "validates uniqueness of user_id scoped to category_id" do
      create(:subscription, user: user, category: category)
      duplicate_subscription = build(:subscription, user: user, category: category)
      expect(duplicate_subscription).not_to be_valid
      expect(duplicate_subscription.errors[:user_id]).to include("already subscribed to this category")
    end
  end
end