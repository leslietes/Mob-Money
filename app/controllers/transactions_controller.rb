class TransactionsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => [:new,:create,:edit,:update,:delete]
  
  def index
    redirect_to root_url
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def balance
    @balance = current_user.balance
  end
  
  def transfer
    if request.post?
      phone  = params[:phone_number]
      amount = params[:amount]
      balance= current_user.balance
      
      if check_invalid_phone_number(phone) == false
        redirect_to transaction_messages_url(:error => "unknown phone number") and return
      end
      
      if check_sufficient_funds(amount) == false
        redirect_to transaction_messages_url(:error => "insufficient funds", :balance => balance) and return
      end
      
      phone_fr=current_user.phone_numbers
      user_to =transfer_to(phone)
      
      debit = Transaction.debit(current_user.id, phone_fr, phone,user_to,amount )
      credit= Transaction.credit(current_user.id,phone_fr, phone,user_to,amount )
      
      flash[:notice] = "You just sent #{amount} to phone number #{phone}."
      redirect_to root_url
    end
  end
  
  def messages
    case params[:error]
      when "unknown phone number"
        @message = "Unknown phone number. If this phone number is correct, please have the owner of this phone register to MobileMoney at the nearest  MobileMoney agent."
      when "insufficient funds"
        @message = "Amount is more than your balance of #{params[:balance]}."
    end
  end
  
  private 
  
  def process_transaction
    
  end
  
  def check_invalid_phone_number(phone)
    UserPhone.phone_number_valid?(phone)
  end
  
  def check_sufficient_funds(amount)
    return true if current_user.balance >= BigDecimal.new(amount)
    return false
  end
  
  def transfer_to(phone)
    UserPhone.find_user(phone) 
  end
  
end
