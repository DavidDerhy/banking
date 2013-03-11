class User < ActiveRecord::Base
  attr_accessible :username, :password

  validates_presence_of :username, :encrypted_password, :balance
  validate :balance => {:greater_than_or_equal_to => 0}

  before_validation :set_default_balance

  def transfer
  end

  def password=(password)
	self.encrypted_password = Digest::SHA512.new(password).to_s
  end

  def set_default_balance
  	self.balance ||= 0
  end
end
