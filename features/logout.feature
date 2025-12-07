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
    When I click on the "Sign Out" link
    Then I should see "Signed out successfully."
    And I should not see the "Logout" link
    And I should not be signed in

  Scenario: Attempting to access protected content after logout
    Given the successful logout scenario has run
    When I attempt to visit "/admin/users"
    Then I should be on the login page
    And I should see "You need to sign in or sign up before continuing."
