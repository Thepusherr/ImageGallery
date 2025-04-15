class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:show]

  def set_posts
    @posts = Post.where(user: @user).order(created_at: :desc) if @user
  end

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    # Show action is handled by set_user before_action
  end

  def edit
    # Edit action is handled by set_user before_action
    authorize_user
  end

  def update
    authorize_user
    
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_user
    
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end

  def authorize_user
    unless current_user == @user
      redirect_to users_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :avatar)
  end
end