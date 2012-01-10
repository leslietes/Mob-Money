class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :user_phones
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email_address
  validates_uniqueness_of :email_address
  
  def self.authenticate(phone_number, password)  
    phone = UserPhone.find_by_phone_number(phone_number)
    if phone
      user  = phone.user
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)  
        user  
      else  
        nil
      end
    end  
  end
  
  def self.authenticate_admin(email_address, password)  
    user = find_by_email_address(email_address)  
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)  
      user  
    else  
      nil  
    end  
  end  
  
  def self.deduct_balance(user_id,amount)
    return false if !exists?(user_id)
    if user = find_by_id(user_id)
      user.balance = user.balance - BigDecimal.new(amount)
      user.save
    end
  end
  
  def self.add_balance(user_id,amount)
    return false if !exists?(user_id)
    if user = find_by_id(user_id)
      user.balance = user.balance + BigDecimal.new(amount)
      user.save
    end
  end
  
  def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
  end  
  
  def is_admin?
    return false if self.user_type.nil?
    if self.user_type == 'Admin'|| self.user_type == 'admin'
      return true
    else
      return false
    end
  end
  
  def mark_as_deleted
    self.deleted = true
  end
  
  def created_by_user
    return '' if self.created_by_user_id.nil?
    User.find_by_id(created_by_user_id,:select => "email_address").email_address
  end
  
  def updated_by_user
    return '' if self.updated_by_user_id.nil?
    User.find_by_id(self.updated_by_user_id,:select => "email_address").email_address
  end
  
  def phone_numbers
    self.user_phones
  end
end
