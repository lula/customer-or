class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :authenticate
  
  protected
  
  def authenticate
    return true if admin_signed_in?
    authenticate_user!
  end
  
end
