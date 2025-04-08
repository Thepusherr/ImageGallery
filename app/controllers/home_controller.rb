class HomeController < ApplicationController
  before_action :posts, only: [:index, :main]

  def posts
    posts_query = if current_user
                    Post.where(user: current_user).order(created_at: :desc)
                  else
                    Post.where(visibility: 0).order(created_at: :desc)
                  end
    
    # Use pagination if available, otherwise just get all posts
    @posts = posts_query.respond_to?(:page) ? posts_query.page(params[:page]) : posts_query
  end

  def index
  end

  def about
  end

  def contact
  end

  def services
  end

  def gallery
  end

  def gallery_single
  end

  def main
  end

  def starter_page
  end
end
