class AdminController < ApplicationController
  before_filter :login_required, :except => ['login']
  before_filter :admin_required, :except => ['login']
  
  def login
    
  end
  
  def index
    
  end
  
  def users
    @users = User.find(:all, :include => [:user_phones])
  end
  
  def transactions
    @transactions = Transaction.find(:all, :order => "created_at ASC")
  end
end
