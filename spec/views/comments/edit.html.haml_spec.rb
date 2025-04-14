require 'rails_helper'

RSpec.describe "comments/edit", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:post_obj) { FactoryBot.create(:post, user: user) }
  let(:comment) {
    Comment.create!(user: user, post: post_obj, text: "Test comment")
  }

  before(:each) do
    assign(:comment, comment)
    # Имитируем current_user для представления
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders the edit comment form" do
    render

    assert_select "form[action=?][method=?]", comment_path(comment), "post" do
    end
  end
end
