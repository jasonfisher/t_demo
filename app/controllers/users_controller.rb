class UsersController < ApplicationController
  def self
    @user = current_user
  end

  def other
  end

  def all
  end

  def index
    if :user_signed_in?
      logger.warn "USER SIGNED IN"
      redirect_to  '/users/signout'
    else

    end
  end

  def signout

  end
end
