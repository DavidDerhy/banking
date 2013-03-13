class User < ActiveRecord::Base
  has_many :debit_logs, :class_name => "TransferLog", :foreign_key => "sender_id" #Logs for my outgoing transactions
  has_many :credit_logs, :class_name => "TransferLog", :foreign_key => "recipient_id" #Logs for my incoming transactions

  attr_accessible :username, :password
  attr_accessor :password
  attr_protected :id, :salt

  validates_presence_of :username, :message => "^Hast thou not been given a name?"
  validates_presence_of :encrypted_password, :balance, :salt
  validates_uniqueness_of :username
  validates_numericality_of :balance
  validate :balance => {:greater_than_or_equal_to => 0}

  before_validation :set_default_balance

  def transfer(recipient_username, amount)
  	amount = amount.to_f.to_d #Make sure amount is a real number
  	if (recipient = User.where(:username => recipient_username).first) && amount > 0 && self.balance - amount >= 0 #User exists, transfers a positive amount, and has money
  		self.balance = self.balance - amount
  		recipient.balance = recipient.balance + amount
  		#Build a log entry of the performed transfer, as a debit for me.
  		debit_log = self.debit_logs.new(:recipient_id => recipient.id, :amount => amount)

  		self.transaction do #Perform transactions simultaneously to prevent errors from stopping the transaction halfway through
  			self.save!
  			recipient.save!
  			debit_log.save!
  		end
  	else
  		false
  	end
  end

  def self.authenticate(username, password)
    #Does user exist? And if so, is password correct?
    if !(user = User.where(:username => username).first).nil? && user.encrypted_password == Digest::SHA512.hexdigest(password+user.salt).to_s
      user
    else
      false
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

  private

  def set_default_balance
    self.balance ||= 0
  end
end
