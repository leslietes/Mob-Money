class TransactionsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => [:new,:create,:edit,:update,:delete]
  
  def index
  end

  def show
    @transaction = Transaction.find_by_id(params[:id])
  end
  
  def new
    @transaction = Transaction.new
  end
  
  def create
     @transaction = Transaction.new(params[:transaction])
    if @transaction.save
      flash[:notice] = "Successfully added transaction."
      redirect_to @transaction
    else
      flash[:error] = "Unable to create transaction. Please check your entries."
      render :action => 'new'
    end
  end
  
  def edit
    @transaction = Transaction.find_by_id(params[:id])
  end
  
  def update
    @transaction = Transaction.find_by_id(params[:id])
    if @transaction.update_attributes(params[:transaction])
      flash[:notice] = "Successfully edited transaction."
      redirect_to transaction_url(@transaction)
    else
      flash[:error] = "Unable to update transaction. Please check your entries"
      render :action => 'edit'
    end
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
      
      Transaction.transaction do
        Transaction.add(current_user.id, phone_fr, phone,user_to,amount )
        User.deduct_balance(current_user.id,amount)
        User.add_balance(user_to,amount)
      end
      
      flash[:notice] = "You have successfully transferred #{amount} to #{user_to.surname} at #{phone}"
      redirect_to balance_url
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
