class TransferLog < ActiveRecord::Base
	#Sender transfers to recipient
	belongs_to :sender, :class_name => "User" #Sending end of the transfer
	belongs_to :recipient, :class_name => "User" #Receiving end of the transfer

	attr_accessible :amount, :sender_id, :recipient_id
end
