class User < ActiveRecord::Base
  has_many :support_tickets
  has_secure_password
end
