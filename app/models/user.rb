class User < ActiveRecord::Base
  attr_accessible :username, :password
  attr_accessor :password
  #attr_writer :password
  attr_protected :id, :salt

  validates_presence_of :username, :message => "^Hast thou not been given a name?"
  validates_presence_of :encrypted_password, :balance, :salt
  validates_uniqueness_of :username
  validate :balance => {:greater_than_or_equal_to => 0}

  before_validation :set_default_balance

  def transfer(recipient_username, amount)
  	if (recipient = User.where(:username => recipient_username).first) && self.balance - amount >= 0
  		self.balance = self.balance - amount
  		recipient.balance = recipient.balance + amount
  		self.transaction do
  			self.save!
  			recipient.save!
  		end
  	else
  		raise "Thou shalt not perform an invalid transfer!"
  	end
  end

  def password=(pass)
  	if pass
	 	self.salt ||= SecureRandom.hex(16) #random string
		self.encrypted_password = Digest::SHA512.hexdigest(pass+self.salt).to_s
	else
  		raise "Thou shalt secure thy account with a password"
  	end
  end

  def set_default_balance
  	self.balance ||= 0
  end

  def self.authenticate(username, password)
  	#Does user exist? And if so, is password correct?
  	!(user = User.where(:username => username).first).nil? && user.encrypted_password == Digest::SHA512.hexdigest(password+user.salt).to_s
  end
end
