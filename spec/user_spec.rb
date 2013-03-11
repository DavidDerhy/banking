describe "User" do
	describe ".create" do		
		it "should set an encrypted password upon creation" do
			user = User.create(:username => "Jesus", :password => "alpha_and_omega")
			user.encrypted_password.should not be nil
		end
		it "should fail if no username is given" do
			expect { User.create(:password => "alpha_and_omega") }.to raise_error
		end
		it "should fail if no password is given" do
			expect { User.create(:username => "Jesus") }.to raise_error
		end
		it "should have a balance of zero" do
			user = User.create(:username => "Jesus", :password => "alpha_and_omega")
			user.balance.should be 0			
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
			@user.transfer(@recipient.username, 70)
			@user.balance.should be 30
			@recipient.balance.should be 70
		end
		it "should fail if the balance would be overdrawn" do
			expect { @user.transfer(@recipient.username, 110) }.to raise_error
			@user.balance.should be 100
			@recipient.balance.should be 0
		end
		it "should fail if the recipient does not exist" do
			expect { @user.transfer("Eve", 70) }.to raise_error
			@user.balance.should be 100
		end
	end
end