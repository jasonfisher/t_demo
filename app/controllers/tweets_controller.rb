class TweetsController < ApplicationController

  # def show_tweets
  #   @user = get_user_or_current_user(params[:id])
  # end

  def new
    @tweet = Tweet.new
  end

  def create
    logger.warn "***** entering with params: " + params.inspect
    @user = current_user
    @content = params[:tweet][:content]
    logger.warn "********* @user: #{@user}, content #{@content} ******************"
    @tweet = Tweet.new
    @tweet.user_id = @user.id
    @tweet.content = @content
    if @tweet.valid?
      logger.warn '*************** VALID ************************'
      @tweet.save!
      redirect_to show_tweets_path(@user.id)
    else
      logger.warn '*************** ERRORS ************************'
      logger.warn @tweet.errors.inspect
      flash.now[:danger] = "ERROR: #{@tweet.errors}"
      redirect_to tweets_new_path()    end
  end

  # def tweet_form
  #   render
  # end
end
