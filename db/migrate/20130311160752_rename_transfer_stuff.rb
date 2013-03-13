class RenameTransferStuff < ActiveRecord::Migration
  def change
  	remove_column :transfer_logs, :recipient
  	remove_column :transfer_logs, :sender
  	add_column :transfer_logs, :partner_id, :integer
  	add_column :transfer_logs, :user_id, :integer
  end
end
