class Transaction < ActiveRecord::Base
  
  def self.add(current_user_id,phone_fr,phone,user_to,amount)
    
    if Transaction.create(:debit               => amount,
                         :credit               => 0.00,
                         :transaction_type     => "transfer-from",
                         :user_id              => current_user_id,
                         :phone_number         => phone_fr,
                         :counter_user_id      => user_to,
                         :counter_phone_number => phone,
                         :created_by_user_id   => current_user_id,
                         :updated_by_user_id   => 0)
        User.deduct_balance(current_user_id,amount)
        User.add_balance(user_to,amount)
    end
  end
  
  def mark_as_deleted
    self.deleted = true
  end
  
  def created_by_user
    return '' if self.created_by_user_id.nil?
    if user = User.find_by_id(created_by_user_id,:select => "email_address")
      user.email_address 
    end
  end
  
  def updated_by_user
    return '' if self.updated_by_user_id.nil?
    if user = User.find_by_id(self.updated_by_user_id,:select => "email_address")
      user.email_address
    end
  end
  
end
