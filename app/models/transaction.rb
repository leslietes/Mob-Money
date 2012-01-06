class Transaction < ActiveRecord::Base
  def mark_as_deleted
    self.deleted = true
  end
end
