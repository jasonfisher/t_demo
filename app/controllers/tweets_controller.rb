class TweetsController < ApplicationController

  def show_tweets
    @user = get_user_or_current_user(params[:id])
  end

  def create_tweet
    @user = current_user
    @content = params[:content]
    @tweet = Tweet.create(:user_id => @user.id, :content => @content)

  end

  # def tweet_form
  #   render
  # end
end
