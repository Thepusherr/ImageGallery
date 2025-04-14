require 'rails_helper'

RSpec.describe "likes/show", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    post_obj = FactoryBot.create(:post, user: user)
    assign(:like, Like.create!(user: user, post: post_obj))
    
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders attributes in <p>" do
    render
  end
end
