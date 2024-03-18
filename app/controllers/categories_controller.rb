class CategoriesController < ApplicationController
  before_action :categories

  def show
  end

  def categories
    @categories = Category.where(user: current_user).order(created_at: :desc)
  end
end
