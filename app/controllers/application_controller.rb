class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session # :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_filter :authenticate_user!

  # after_filter :set_xhr_flash
  # 
  # def set_xhr_flash
  #   # flash.discard if request.xhr?
  # end
  
  protected
  
  def current_auth_resource
    current_user
  end
  
  def current_ability
    @current_ability || @current_ability = Ability.new(current_auth_resource)
  end
  
end
