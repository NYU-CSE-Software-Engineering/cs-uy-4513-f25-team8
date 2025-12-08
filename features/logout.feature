Feature: User Logout
  As an authenticated user
  I want to be able to sign out
  So that my session ends securely

  Background:
    Given the following users exist:
      | username | email       | password | role   |
      | jing     | j@q.com     | meowww   | admin  |

    And I am on the login page
    And I fill in the login field "user_email" with "j@q.com"
    And I fill in the login field "user_password" with "meowww"
    And I press "Log in"

  Scenario: Successful logout
    When I press "Sign Out"
    Then I should see "Signed out successfully."

  Scenario: Logging out and then trying to access protected content
    When I press "Sign Out"
    When I attempt to visit "/admin/users"
    Then I should be on the login page
    And I should see "You need to sign in or sign up before continuing."
