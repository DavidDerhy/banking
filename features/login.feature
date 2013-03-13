Feature: Log in to my account
	In order to view my account
	As a user
	I want to log in

	Scenario: User performs valid login
		Given I am a user
		When I log in with a valid password
		Then I should be logged in correctly

	Scenario: User performs invalid login
		Given I am a user
		When I log in with an invalid password
		Then I should not be logged in	