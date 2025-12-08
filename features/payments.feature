Feature: Payments for bookings
  As a renter
  I want to pay for my approved booking
  So that my rental is confirmed and recorded

  Background:
    Given a signed-in renter with an approved booking

  Scenario: See accurate payment breakdown before paying
    When I visit the payment page for that booking
    Then I should see the payment breakdown

  Scenario: Successful deposit payment
    Given I am on the payment page for that booking
    When I choose "Deposit" as the payment type
    And I submit the payment form
    Then I should see the payment success message
