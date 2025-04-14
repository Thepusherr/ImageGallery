class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

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
    
    redirect_to post_path(@post), notice: 'Like removed successfully.'
  rescue => e
    Rails.logger.error("Error destroying like: #{e.message}")
    redirect_to posts_path, alert: 'An error occurred while removing the like.'
  end
end
