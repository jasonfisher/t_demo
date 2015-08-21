class UsersController < ApplicationController

  before_action :authenticate_user!

  def home
    redirect_to show_user_path(current_user.id)
  end

  def show
    id = params[:id]
    logger.warn "########################### ID: #{id}"
    logger.warn "########################### current_user: #{current_user.inspect}"

    #set user to current_user if going to their own page, or to an invalid id
    # (we want to not reward tinkering behavior with user ids that don't exist.. just send them to their own page)
    @is_current_user = (id == current_user.id)
    @user = @is_current_user ? current_user : User.find_by_id(id)
    if @user.nil?
      @user = current_user
      @is_current_user = true
    end
    logger.warn "########################### @is_current_user: #{@is_current_user}"
    logger.warn "########################### @user #{@user}"

  end

  def show_followers
    @user = User.find_by_id(params[:id])
    @followers = @user.followers
  end

end
