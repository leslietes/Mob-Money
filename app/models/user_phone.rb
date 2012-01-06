class UserPhone < ActiveRecord::Base
  belongs_to :user
  def mark_as_deleted
    self.deleted = true
  end
end
