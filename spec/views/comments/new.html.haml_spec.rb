require 'rails_helper'

RSpec.describe "comments/new", type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post, user: user)
    assign(:comment, Comment.new(user: user, post: post, text: "Test comment"))
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do
    end
  end
end
