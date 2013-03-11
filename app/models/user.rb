class User < ActiveRecord::Base
  attr_accessible :encrypted_password, :username
end
