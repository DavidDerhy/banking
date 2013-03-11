class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :encrypted_password
      t.string :username
      t.decimal :balance

      t.timestamps
    end
  end
end
