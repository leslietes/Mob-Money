class Interface < ActiveRecord::Base
  validates_presence_of :screen, :element
end
