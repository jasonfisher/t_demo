class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

#TODO: move to helper method
  #set user to current_user if going to their own page, or to an invalid id
  # (we want to not reward tinkering behavior with user ids that don't exist.. just send them to their own page)
  def get_user_or_current_user(id)
    id = params[:id]
    if id == current_user.id
      return current_user
    end
    @user = User.find_by_id(id)
    if @user.nil?
      return current_user
    else
      return @user
    end

  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

end
