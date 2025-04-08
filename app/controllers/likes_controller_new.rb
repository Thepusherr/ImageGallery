class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :toggle_like]
  before_action :set_post, only: [:create, :toggle_like]
  before_action :set_like, only: [:destroy]

  def index
    @likes = Like.all
  end

  def show
    @like = Like.find(params[:id])
  end

  def new
    @like = Like.new
  end

  def edit
    @like = Like.find(params[:id])
  end

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)
    
    if @like.save
      redirect_to post_path(@post), notice: 'Post liked successfully.'
    else
      redirect_to post_path(@post), alert: 'Unable to like post.'
    end
  rescue => e
    Rails.logger.error("Error creating like: #{e.message}")
    redirect_to post_path(@post || Post.find(params[:post_id])), alert: 'Unable to like post.'
  end

  def update
    @like = Like.find(params[:id])
    if @like.update(like_params)
      redirect_to like_url(@like), notice: "Like was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    @like.destroy
    redirect_to post_path(@post), notice: 'Like removed successfully.'
  rescue => e
    Rails.logger.error("Error destroying like: #{e.message}")
    redirect_to post_path(@post || Like.find(params[:id]).post), alert: 'Unable to unlike post.'
  end

  def toggle_like
    if(@like = @post.likes.find_by(user: current_user))
      @like.destroy
      action = 'unliked'
    else
      @post.likes.create(user: current_user)
      action = 'liked'
    end

    # Skip logging in test environment
    unless Rails.env.test?
      if defined?(UserEventLogger)
        begin
          UserEventLogger.log(
            user: current_user,
            action_type: action,
            url: url_for(:only_path => false) # request.fullpath
          )
        rescue => e
          Rails.logger.error("Error logging user event: #{e.message}")
        end
      end
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "post#{@post.id}actions",
          partial: "posts/post_actions",
          locals: { post: @post }
        )
      end
      format.html { redirect_to post_path(@post) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id]) if params[:post_id]
  end

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:post_id, :user_id)
  end
end