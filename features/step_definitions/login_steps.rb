Given /^I am a user$/ do
	@user = User.create(:username => "Jesus", :password => "alpha_and_omega")
end

Given /^I am logged in as a user with money$/ do
	step %(I am a user)
	#Set the user's balance
	@user.balance = 10
	@user.save!
	step %(I log in with a valid password)
end

When /^I log in with a valid password$/ do
	visit "/login"
	fill_in "user_username", :with => "Jesus"
	fill_in "user_password", :with => "alpha_and_omega"
	click_button "Login"
end

Then /^I should be logged in correctly$/ do
	page.should have_content "Welcome, my child."
	current_url.should == "http://www.example.com/transfer"
end

When /^I log in with an invalid password$/ do
	visit "/login"
	fill_in "user_username", :with => "Jesus"
	fill_in "user_password", :with => "beta_and_pi"
	click_button "Login"
end

Then /^I should not be logged in$/ do
	page.should have_content "Thou shall not pass!"
	current_url.should == "http://www.example.com/login"
end