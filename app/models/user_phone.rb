class UserPhone < ActiveRecord::Base
  validates_uniqueness_of :phone_number
  belongs_to :user
  def mark_as_deleted
    self.deleted = true
  end
end
