class AdminController < ApplicationController
  before_filter :login_required, :except => ['login']
  before_filter :admin_required, :except => ['login']
  
  def login
    
  end
  
  def index
    @user_count = User.all.count
    @trans_count= Transaction.all.count
    @balance    = User.sum(:balance)
    @trans_sum  = Transaction.average(:credit) * 2
  end
  
  def users
    @users = User.find(:all, :include => [:user_phones])
  end
  
  def transactions
    @transactions = Transaction.find(:all, :order => "created_at ASC")
  end
end
