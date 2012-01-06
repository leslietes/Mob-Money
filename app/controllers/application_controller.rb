class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  def login_required
    if current_user
      return true
    else
      redirect_to login_url
    end
  end
  
  def admin_required
    if current_user && current_user.is_admin?
      return  true 
    else
      redirect_to root_url
    end
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
