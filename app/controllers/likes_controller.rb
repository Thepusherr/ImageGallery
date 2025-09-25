class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :toggle_like]

  def new
    @like = Like.new
    # Для тестов
    if params[:post_id]
      @post = Post.find(params[:post_id])
    end
  end

  def create
    @post = Post.find_by(id: params[:post_id])

    if @post.nil?
      redirect_to posts_path, alert: 'Post not found.'
      return
    end

    @like = Like.new(post: @post, user: current_user)

    if @like.save
      # Log the like event
      unless Rails.env.test?
        if defined?(UserEventLogger)
          begin
            UserEventLogger.log(
              user: current_user,
              action_type: 'liked',
              url: post_path(@post)
            )
          rescue => e
            Rails.logger.error("Error logging like event: #{e.message}")
          end
        end
      end

      redirect_to post_path(@post), notice: 'Post liked successfully.'
    else
      redirect_to post_path(@post), alert: 'Unable to like post.'
    end
  rescue => e
    Rails.logger.error("Error creating like: #{e.message}")
    redirect_to posts_path, alert: 'An error occurred while liking the post.'
  end

  def destroy
    @like = Like.find_by(id: params[:id])

    if @like.nil?
      redirect_to posts_path, alert: 'Like not found.'
      return
    end

    @post = @like.post
    @like.destroy

    # Log the unlike event
    unless Rails.env.test?
      if defined?(UserEventLogger)
        begin
          UserEventLogger.log(
            user: current_user,
            action_type: 'unliked',
            url: post_path(@post)
          )
        rescue => e
          Rails.logger.error("Error logging unlike event: #{e.message}")
        end
      end
    end

    redirect_to post_path(@post), notice: 'Like removed successfully.'
  rescue => e
    Rails.logger.error("Error destroying like: #{e.message}")
    redirect_to posts_path, alert: 'An error occurred while removing the like.'
  end

  def toggle_like
    @post = Post.find_by(id: params[:post_id])

    if @post.nil?
      Rails.logger.error("Post not found with id: #{params[:post_id]}")
      respond_to do |format|
        format.turbo_stream { head :not_found }
        format.html { redirect_back(fallback_location: root_path, alert: 'Post not found') }
      end
      return
    end

    existing_like = @post.likes.find_by(user: current_user)

    if existing_like
      # Unlike
      existing_like.destroy
      @like = nil
      Rails.logger.info("User #{current_user.id} unliked post #{@post.id}")
    else
      # Like
      @like = @post.likes.create(user: current_user)
      Rails.logger.info("User #{current_user.id} liked post #{@post.id}")
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}actions", partial: "posts/post_actions", locals: { post: @post }) }
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render json: { success: true, liked: @like.present? } }
    end
  rescue => e
    Rails.logger.error("Error toggling like: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    respond_to do |format|
      format.turbo_stream { head :internal_server_error }
      format.html { redirect_back(fallback_location: root_path, alert: 'An error occurred while processing your request') }
    end
  end
end
