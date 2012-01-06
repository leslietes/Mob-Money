class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:phone_number], params[:password])  
    if user  
      session[:user_id] = user.id  
      redirect_to root_url, :notice => "Logged in!"  
    else  
      flash.now.alert = "Invalid phone number or password"  
      render "new"  
    end  
  end
  
  def create_admin
    user = User.authenticate_admin(params[:email_address], params[:password])  
    if user  
      session[:user_id] = user.id  
      redirect_to admin_url, :notice => "Logged in!"  
    else  
      flash.now.alert = "Invalid email or password"  
      render "new"  
    end  
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
