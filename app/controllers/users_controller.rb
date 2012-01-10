class UsersController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  def new  
    @user = User.new  
  end  
    
  def create  
    @user = User.new(params[:user])  
    @user.created_by_user_id = current_user.id if !current_user.nil?
    phone = UserPhone.new(:phone_number => params[:phone_number].to_i)
    @user.user_phones << phone
    if @user.save
      redirect_to admin_users_url, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end
  
  def show
    @user = User.find_by_id(params[:id], :include => [:user_phones])
  end
  
  def edit
    @user = User.find_by_id(params[:id])
  end
  
  def update
    @user = User.find_by_id(params[:id])
    @user.updated_by_user_id = current_user.id if !current_user.nil?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully edited user."
      redirect_to user_url(@user)
    else
      flash[:error] = "Unable to update user. Please check your entries"
      render :action => 'edit'
    end
  end
  
  def delete
    @user = User.find_by_id(params[:id])
    @user.mark_as_deleted
    if @user.save
      flash[:notice] = "Successfully deleted user."
    else
      flash[:error] = "Error in deleting user."
    end
    redirect_to admin_users_url
  end
  
  def user_phones
    return unless request.post?
    @user = User.find_by_id(params[:user_id])
    phone = UserPhone.create(:phone_number => params[:phone_number], :user_id => params[:user_id])
    if phone.save
      flash[:notice] = "Successfully added phone number"
      redirect_to user_url(@user)
    else
      flash[:error] = "Unable to add phone number"
      render :action => 'show'
    end
  end
  
  def delete_user_phones
    
  end
end
