class UsersController < ApplicationController

  before_action :authenticate_user!

  def home
    redirect_to show_user_path(current_user.id)
  end

  def show
    @user = get_user_or_current_user(params[:id])
  end

  def show_followers
    @user = get_user_or_current_user(params[:id])
    @followers = @user.followers
  end

  def show_followeds
    @user = get_user_or_current_user(params[:id])
    @followeds = @user.followeds
  end
end
