class User < ActiveRecord::Base
  has_many :support_tickets
end
