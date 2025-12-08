Feature: User Login
  Background:
    Given the following users exist:
      | username | email                | password           | role   |
      | kyle     | kyle.jia@nyu.edu     | Team8isTheBest123! | renter |
    And I am on the login page
    And I fill in the login field "user_email" with "kyle.jia@nyu.edu"
    And I fill in the login field "user_password" with "Team8isTheBest123!"

  Scenario: Successful login
    When I press "Log in"
    Then I should see "Signed in successfully."
