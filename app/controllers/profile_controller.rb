class ProfileController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  
  def index
    redirect_to edit_user_registration_path
  end
  
  def show
    @user = User.find(params[:id])
  end
end
