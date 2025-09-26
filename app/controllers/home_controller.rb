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
    begin
      if params[:category_id].present?
        @selected_category = Category.friendly.find(params[:category_id])
        @posts = @selected_category.posts.where(visibility: :visible).includes(:user)
      else
        @selected_category = nil
        # Show only posts with categories (as per requirements)
        @posts = Post.joins(:categories).where(visibility: :visible).includes(:user, :categories).distinct
      end

      @posts = @posts.select { |post| post.image.present? }
    rescue ActiveRecord::RecordNotFound
      @posts = Post.joins(:categories).where(visibility: :visible).includes(:user, :categories).distinct.select { |post| post.image.present? }
      @selected_category = nil
    end
  end

  def gallery_single
  end

  def main
  end

  def starter_page
  end

  def test_turbo
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("turbo-result", "<div id='turbo-result'>Turbo is working! Time: #{Time.current}</div>")
      end
      format.html { redirect_to root_path, notice: "Turbo test completed" }
    end
  end

end
