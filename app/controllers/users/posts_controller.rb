class Users::PostsController < ApplicationController
  before_action :set_user, only: [:index]
  before_action :authenticate_user!, only: [:my_posts]

  def index
    # Show only posts with categories (as per requirements)
    @posts = @user.posts.joins(:categories).where(visibility: :visible).order(created_at: :desc).distinct
    @posts = @posts.select { |post| post.image.present? }
  end

  def my_posts
    @user = current_user
    # For own posts, show all posts (including those without categories)
    @posts = @user.posts.order(created_at: :desc)
    @posts = @posts.select { |post| post.image.present? }
    render :index
  end

  private

  def set_user
    @user = User.friendly.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end
end
