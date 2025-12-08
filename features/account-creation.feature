Feature: Create a new account
  As a new user without an account
  I want to create an account
  So that I can have access to the renting and lending features

  Scenario: User clicks on the "Sign Up" button
    Given I am a new user
    And I am on any page with a "Sign Up" button
    When I click on the "Sign Up" button
    Then I should be on the account creation form

  Scenario: User creates an account with valid information
    Given I am a new user
    And I am on the account creation form
    When I fill in "Username" with "new_user"
    And I fill in "Email" with "new_user@example.com"
    And I fill in "Password" with "password"
    And I press "Create Account"
    Then I should be where I was before clicking "Sign Up"
    And I should see the message "Account successfully created"
    And I should be signed in

  Scenario: User fails to create an account due to an invalid username
    Given I am a new user
    And I am on the account creation form
    When I leave "Username" blank
    And I fill in "Password" with "password"
    And I press "Create Account"
    Then I should see an error message saying the account name is invalid

