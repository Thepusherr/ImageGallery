class HomeController < ApplicationController
  before_action :posts

  def posts
    @posts =  Post.where(user: current_user).order(created_at: :desc)
  end
  def index
  end
end
