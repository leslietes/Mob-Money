class TransactionsController < ApplicationController
  
  def balance
    @balance = '1000'
  end
  
  def transfer
      if request.post?
        phone  = params[:phone_number]
        amount = params[:amount]
        flash[:notice] = "You just sent #{amount} to phone number #{phone}."
        redirect_to transfer_url
      end
  end
end
