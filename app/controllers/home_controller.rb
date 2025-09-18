class HomeController < ApplicationController
  before_action :load_posts, only: [:index, :main]

  def load_posts
    begin
      posts_query = if current_user
                      Post.where(user: current_user).order(created_at: :desc)
                    else
                      Post.where(visibility: 0).order(created_at: :desc)
                    end
      
      # Use pagination if available, otherwise just get all posts
      if defined?(Kaminari) && posts_query.respond_to?(:page)
        @posts = posts_query.page(params[:page])
      else
        @posts = posts_query.to_a
      end
    rescue => e
      # В случае ошибки, просто создаем пустой массив
      @posts = []
      Rails.logger.error("Error loading posts: #{e.message}")
    end
  end

  def index
    # Метод load_posts уже вызван через before_action
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
