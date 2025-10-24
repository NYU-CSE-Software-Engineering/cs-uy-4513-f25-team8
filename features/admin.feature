@admin @user_management
Feature: Administrative User Management
  As an Admin
  I want to moderate all user accounts (disable/enable) and view their details
  So that I can maintain platform safety and integrity

  # AC1 & AC2 - View & Filter All Users
  @happy_path
  Scenario: Admin successfully views and filters the user list
    Given the following users exist:
      | username | email                | role    | account_status | report_count |
      | Kyle     | kyle@example.com     | renter  | active         | 0            |
      | Lily     | lily@example.com     | owner   | active         | 3            |
      | Erfu     | erfu@example.com     | admin   | active         | 1            |
    And I am signed in as an Admin
    When I visit the User Management Dashboard
    Then I should see the following user details:
      | username | role    | account_status | report_count |
      | Kyle     | renter  | active         | 0            |
      | Lily     | owner   | active         | 3            |
      | Erfu     | admin   | active         | 1            |
    When I search for "lily@example.com"
    Then I should see the user "Lily"
    And I should not see the user "Kyle"

  # AC3 - Disable/Ban a User
  @sad_path
  Scenario: Admin disables a reported user's account
    Given the user "Lily" exists with role "owner" and account status "active"
    And I am signed in as an Admin
    When I visit the Admin user profile page for "Lily"
    And I click the "Disable Account" button
    Then I should see the message "User Lily's account has been disabled."
    And the user "Lily" should have account status "disabled" in the database
    When the user "Lily" attempts to sign in with valid credentials
    Then they should see the message "Your account has been disabled."

  # AC4 - Re-enable a User
  @happy_path
  Scenario: Admin re-enables a previously disabled account
    Given the user "Kyle" exists with role "renter" and account status "disabled"
    And I am signed in as an Admin
    When I visit the Admin user profile page for "Kyle"
    And I click the "Enable Account" button
    Then I should see the message "User Kyle's account has been enabled."
    And the user "Kyle" should have account status "active" in the database
    When the user "Kyle" attempts to sign in with valid credentials
    Then they should be signed in successfully

  # AC5 - Admin can remove an inappropriate listing
  @moderation @sad_path
  Scenario: Admin removes an item listing after it has been flagged
    Given a listing exists titled "Inappropriate Content" owned by user "Erfu"
    And the listing "Inappropriate Content" has been flagged for review
    And I am signed in as an Admin
    When I visit the listing page for "Inappropriate Content"
    And I click the "Remove Listing" button
    Then I should see the message "The listing 'Inappropriate Content' has been successfully removed."
    And the listing "Inappropriate Content" should not exist in the database
    And the user "Erfu" should receive a notification that their listing was removed
    And the user "Erfu" should have a report_count of 1

  # AC6 - Authorization failure for non-Admins
  @security
  Scenario: A Renter cannot access the User Management Dashboard
    Given I am signed in as a Renter
    When I try to visit the User Management Dashboard path
    Then I should be on the home page
    And I should see the error message "You are not authorized to view this page."