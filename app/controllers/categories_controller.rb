class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy show_image]
  before_action :categories

  def show
    @posts_with_images = @category.posts.select { |post| post.image.attached? }
    #@category_images = @category.posts.where(user: current_user).select { |post| post.image.attached? }.map(&:image)
  end

  def new
    @category = Category.new
  end

  def categories
    @categories = Category.where(user: current_user).order(created_at: :desc)
    @popular_categories = Category
    .left_joins(posts: [:likes, :comments])
    .select(
      'categories.*, COUNT(posts.id) AS posts_count, COUNT(likes.id) AS likes_count, COUNT(comments.id) AS comments_count'
    )
    .group('categories.id')
    .order('posts_count DESC, likes_count DESC, comments_count DESC')
    .limit(5)
  
    # @all_categories_with_images = @categories.includes(posts: { image_attachment: :blob }).map do |category|
    #   category_image = category.posts.where(user: current_user).find { |post| post.image.attached? }&.image
    #   { category: category, image: category_image }
    # end

    @categories_with_images = @popular_categories.includes(posts: { image_attachment: :blob }).map do |category|
      category_image = category.posts.find { |post| post.image.attached? }&.image
      { category: category, image: category_image }
    end
  end

  def create
    @category = current_user.categories.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: @category.errors.full_messages }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    return if current_user != current_user.categories.first.user

    if @category.destroy
      respond_to do |format|
        format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to categories_url, notice: "Failed to delete the category." }
        format.json { head :no_content }
      end
    end
  end

  def show_image
    @posts_with_images = @category.posts.select { |post| post.image.attached? }
    @current_image_index = params[:image_index].to_i

    if @current_image_index < 1 || @current_image_index > @posts_with_images.size
      redirect_to category_path(@category), alert: 'Invalid image index'
    end
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end
