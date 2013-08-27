class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_filter :authenticate
  
  protected
  
  def authenticate
    return :authenticate_admin! if admin_signed_in?
    authenticate_user!
  end
  
  def current_auth_resource
    if admin_signed_in?
      current_admin
    else
      current_user
    end
  end

  def current_ability
      @current_ability || @current_ability = Ability.new(current_auth_resource)
  end
  
end