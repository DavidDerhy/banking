class ChangeReceiverAndSenderTransferLogs < ActiveRecord::Migration
  def change
  	remove_column :transfer_logs, :partner_id
  	remove_column :transfer_logs, :user_id
  	add_column :transfer_logs, :sender_id, :integer
  	add_column :transfer_logs, :recipient_id, :integer
  end
end
