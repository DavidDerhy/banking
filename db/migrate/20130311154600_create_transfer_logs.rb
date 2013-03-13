class CreateTransferLogs < ActiveRecord::Migration
  def change
    create_table :transfer_logs do |t|
      t.integer :recipient
      t.integer :sender
      t.decimal :amount

      t.timestamps
    end
  end
end
