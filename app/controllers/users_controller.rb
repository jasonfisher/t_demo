class UsersController < ApplicationController

  before_action :authenticate_user!

  def home
    redirect_to show_user_path(current_user.id)
  end

#TODO: refactor check for current user and redirects when not correct
# (can't seem to change /id in url due to circular redirect, might want to just show indication user doesn't exist, or add a route without an id?)
  def show
    @user = get_user_or_current_user(params[:id])
    @is_current_user = (@user.id == current_user.id)
  end

  def show_followers
    @user = get_user_or_current_user(params[:id])
    @followers = @user.followers
  end

  def show_followeds
    @user = get_user_or_current_user(params[:id])
    @followeds = @user.followeds
  end

#TODO: added ordering near end of dev, add test for this
  def show_tweets
    @user = get_user_or_current_user(params[:id])
    @tweets = Tweet.where(:user_id => @user.id).order(created_at: :desc)
  end

  def show_unfollowed_users
    @user = get_user_or_current_user(params[:id])
    @unfollowed_users = @user.unfollowed_users
  end

  def follow_user
    @user_to_follow = User.find_by_id(params[:id])
#TODO: handle error cases: user does not exist, user is already following, call to user.follow fails with error
#TODO: do better redirect with next link as param somehow
    current_user.follow(@user_to_follow)
    redirect_to root_path
  end

  def unfollow_user
    @user_to_unfollow = User.find_by_id(params[:id])
#TODO: handle error cases: user does not exist, user is already following, call to user.follow fails with error
#TODO: do better redirect with next link as param somehow
    current_user.unfollow(@user_to_unfollow)
    redirect_to root_path
  end

end
