require 'spec_helper.rb'

describe "User" do
	describe ".create" do		
		it "should set an encrypted password upon creation" do
			user = User.create(:username => "Jesus", :password => "alpha_and_omega")
			user.encrypted_password.should_not be nil
		end
		it "should fail if no username is given" do
			User.create(:password => "alpha_and_omega").errors.should_not be_empty
		end
		it "should fail if no password is given" do
			User.create(:username => "Jesus").errors.should_not be_empty
		end
		it "should have a balance of zero" do
			user = User.create(:username => "Jesus", :password => "alpha_and_omega")
			user.balance.should eq 0			
		end
	end
	describe ".transfer(recipient, amount)" do
		before(:each) do
			@user = User.create(:username => "Jesus", :password => "alpha_and_omega")
			@recipient = User.create(:username => "Adam", :password => "apple")
			@user.balance = 100
			@user.save
		end
		it "should transfer the amount from user to recipient" do
  			@user.transfer("Adam", 70)
			@user.balance.should eq 30
			User.where(:username => @recipient.username).first.balance.should eq 70
		end
		it "should fail if the balance would be overdrawn" do
			@user.transfer("Adam", 110).should be false
			@user.balance.should eq 100
			User.where(:username => @recipient.username).first.balance.should eq 0
		end
		it "should fail if the recipient does not exist" do
			@user.transfer("Eve", 70).should be false
			@user.balance.should eq 100
		end
		it "should log the transfer" do
  			@user.transfer("Adam", 70)
			@user.debit_logs.last.amount.should eq 70			
			@recipient.credit_logs.last.amount.should eq 70			
		end
		it "should not transfer negative amounts" do
			@user.transfer("Adam", -70).should be false
			@user.balance.should eq 100
		end
		it "should not accept strings as input" do
			@user.transfer("Adam", "Snake").should be false
			@user.balance.should eq 100
		end
	end
	describe "self.authanticate(username, password)" do
		before(:each) do
			@user = User.create(:username => "Jesus", :password => "alpha_and_omega")
		end
		it "should return the user if username and password match" do
			User.authenticate("Jesus", "alpha_and_omega").should eq @user
		end
		it "should return false if username does not exist" do
			User.authenticate("Judas", "alpha_and_omega").should be false
		end
		it "should return false if password is incorrect" do
			User.authenticate("Jesus", "unicorns").should be false
		end
	end
end