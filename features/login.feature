Feature: User Login
  Background:
    Given I am on the login page
    And I fill in the login field "Email" with "kyle.jia@nyu.edu"
    And I fill in the login field "Password" with "Team8isTheBest123!"

  Scenario: Successful login
    When I press "Log in"
    Then I should see "Welcome back!"
    And I should see the "Dashboard" link
    And the page title should be "User Dashboard"