Feature: Request and approve a booking
  As a signed-in renter
  I want to request a booking for an available item and have the owner approve it
  So that the booking lifecycle can progress from requested -> approved -> active

  Background:
    Given the following users exist:
      | username | role   |
      | isabelle | renter |
      | erfu     | owner  |
    And the following item exists:
      | title  | owner | availability_status |
      | Camera | erfu  | available           |
    And I am signed in as "isabelle"
    And I am on the item details page for "Camera"

  Scenario: Renter requests an available item and owner approves
    When I request the item "Camera" for "2025-03-21" to "2025-06-21"
    Then I should see "Booking request submitted"
    And a booking should exist in the database with status "requested"
    When I sign out
    And I sign in as "erfu"
    And I visit the owner dashboard and open the booking request for "Camera"
    And I click "Approve Booking"
    Then the booking's status should be "approved"
    And the renter "isabelle" should receive a notification "Your booking for Camera has been approved"