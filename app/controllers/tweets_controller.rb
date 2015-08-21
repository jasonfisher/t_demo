class TweetsController < ApplicationController

  def show_tweets
    @user = get_user_or_current_user(params[:id])
  end
end
