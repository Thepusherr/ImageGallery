# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts/edit', type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:post) do
    Post.create!(user: user, title: 'Test Post', text: 'Test content')
  end

  before(:each) do
    assign(:post, post)
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'renders the edit post form' do
    render

    assert_select 'form[action=?][method=?]', post_path(post), 'post' do
    end
  end
end
