Feature: Transfer money
	In order to pay my dues
	As a user
	I want to transfer money

	Scenario: Users transfers money to recipient
		Given there is a recipient
		And I am logged in as a user with money
		When I transfer money to the recipient
		Then I should see my new balance
		And I should see my transfer record 