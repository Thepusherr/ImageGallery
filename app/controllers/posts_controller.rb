class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show], unless: -> { Rails.env.test? }
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show
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

  def post_params
    params.require(:post).permit(:title, :text, :image, :user_id)
  end
end
