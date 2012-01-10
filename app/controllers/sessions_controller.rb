class SessionsController < ApplicationController
  before_filter :check_phone_number_if_registered, :only => [:create]
  before_filter :check_email_if_registered, :only => [:create_admin]
  def new
  end

  def create
    user = User.authenticate(params[:phone_number], params[:password])  
    if user  
      session[:user_id] = user.id  
      session[:phone_no]= params[:phone_number]
      redirect_to root_url, :notice => "Logged in!"  
    else
      redirect_to error_message_sessions_url(:error => "invalid credentials")
      #flash.now.alert = "Invalid phone number or password"  
      #render "new"  
    end  
  end
  
  def create_admin
    user = User.authenticate_admin(params[:email_address], params[:password])  
    if user  
      session[:user_id] = user.id  
      redirect_to admin_url, :notice => "Logged in!"  
    else
      redirect_to error_message_sessions_url(:error => "invalid admin credentials")
      #flash.now.alert = "Invalid email or password"  
      #render "new"  
    end  
  end
  
  def destroy
    session[:user_id] = nil
    session[:phone_no]= nil
    redirect_to root_url, :notice => "Logged out!"
  end
  
  def error_message
    case params[:error]
      when "unregistered phone number"
        @message = "Your phone is not currently registered for MobileMoney. Please visit your nearest MobileMoney agent to register your phone."
      when "invalid credentials"
        @message = "You have entered an invalid phone number and password combination. Please try again"
      when "unregistered email address"
        @message = "You have entered an unregistered email address. Please try again with a different email address or contact MobileMoney support."
      when "invalid admin credentials"
        @message = "You have entered an incorrect email address and password combination. Please try again."
      else
        @message = ""
    end
  end
  
  def check_phone_number_if_registered
    if UserPhone.find_by_phone_number(params[:phone_number]).nil?
      redirect_to error_message_sessions_url(:error => "unregistered phone number") 
      return
    end
  end
  
  def check_email_if_registered
    if User.find_by_email_address(params[:email_address]).nil?
      redirect_to error_message_sessions_url(:error => "unregistered email address") 
      return
    end
  end
end
