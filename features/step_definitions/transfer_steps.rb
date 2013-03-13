Given /^there is a recipient$/ do
	@recipient = User.create(:username => "Adam", :password => "apple")
end

When /^I transfer money to the recipient$/ do
	fill_in "recipient_amount", :with => "1.50"
	select("Adam", :from => "recipient_username")
	click_button "Transfer"
end

Then /^I should see my new balance$/ do
	#User had $10, transferred $1,50
	page.should have_content "Balance $8.50"
	page.should have_content "1.50 transferred to Adam"
end

Then /^I should see my transfer record$/ do
	history = find_by_id("history")
	history.should have_content("Adam")
	history.should have_content("Jesus")
	history.should have_content("$1.50")
end
