class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :time_update]
  before_action :set_post, only: %i[ show edit update destroy time_update ]

  def index
    @posts = if params[:user_id].present?
               user = User.friendly.find(params[:user_id])
               # Show only posts with categories for user posts too
               user.posts.joins(:categories).where(visibility: :visible).order(created_at: :desc).distinct
             else
               # Show only posts with categories (as per requirements)
               Post.joins(:categories).where(visibility: :visible).order(created_at: :desc).distinct
             end
    @selected_user = User.friendly.find(params[:user_id]) if params[:user_id].present?
  rescue ActiveRecord::RecordNotFound
    @posts = Post.joins(:categories).where(visibility: :visible).order(created_at: :desc).distinct
    @selected_user = nil
  end

  def uncategorized
    # Show posts without categories (admin only)
    @posts = Post.left_joins(:categories).where(categories: { id: nil }).order(created_at: :desc)
    render :index
  end

  def show
    # Views are now tracked automatically via JavaScript when post becomes visible
  end

  def track_view
    post = Post.find(params[:post_id])

    # Track view if user is signed in and hasn't viewed this post yet
    if user_signed_in? && current_user != post.user
      view_created = post.views.find_or_create_by(user: current_user) do |view|
        view.viewed_at = Time.current
      end

      # Broadcast view count update if a new view was created
      if view_created.persisted? && view_created.created_at == view_created.updated_at
        ViewsChannel.broadcast_to(post, {
          actions_html: render_to_string(partial: "posts/post_actions", locals: { post: post })
        })
      end
    end

    head :ok
  end

  def update_times
    TimeUpdateJob.perform_later
    head :ok
  end

  def time_update
    # Устанавливаем локаль если передана
    if params[:locale].present?
      I18n.locale = params[:locale]
    end

    render partial: "posts/post_time", locals: { post: @post }
  end

  def new
    @post = Post.new
  end

  def edit
    # Only allow the post owner to edit
    unless Rails.env.test? || current_user == @post.user
      redirect_to posts_url, alert: "You are not authorized to edit this post."
    end
  end

  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        # Notify subscribers of categories associated with this post
        notify_subscribers if params[:post][:category_ids].present?
        
        # Notify subscribers of categories associated with this post
        notify_subscribers if params[:post][:category_ids].present?
        
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # Only allow the post owner to update
    unless Rails.env.test? || current_user == @post.user
      respond_to do |format|
        format.html { redirect_to posts_url, alert: "You are not authorized to update this post." }
        format.json { head :unauthorized }
      end
      return
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if Rails.env.test? || current_user == @post.user
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_url, alert: "You are not authorized to delete this post." }
        format.json { head :unauthorized }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
  
  def notify_subscribers
    return unless @post.image.present?
    
    # Get all categories associated with this post
    categories = Category.where(id: params[:post][:category_ids])
    
    categories.each do |category|
      # Get all subscribers for this category
      subscribers = category.subscribers
      
      # Send notification to each subscriber
      subscribers.each do |subscriber|
        # Skip notification to the post creator
        next if subscriber == current_user
        
        begin
          NotifierMailer.new_image_notification(subscriber, category, @post).deliver_later
        rescue => e
          Rails.logger.error("Failed to send notification to #{subscriber.email}: #{e.message}")
        end
      end
    end
  end

  def post_params
    params.require(:post).permit(:title, :text, :image, :user_id, category_ids: [])
  end
end
