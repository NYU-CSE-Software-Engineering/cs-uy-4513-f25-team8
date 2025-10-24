@payments
Feature: Payment processing for rentals
  As a renter
  I want to pay for my approved booking (deposit if required and the rental fee)
  So that my rental is confirmed and the payment is recorded for the owner and system

  # AC1 — Amount breakdown is visible and accurate before paying
  Scenario Outline: Show accurate amount breakdown before paying
    Given I am a signed-in renter
    And I have an approved booking priced "<price_per_day>" per day for "<days>" days with a deposit of "<deposit>"
    When I open the payment page for that booking
    Then I should see the rental subtotal "<expected_subtotal>"
    And I should see the deposit "<deposit>"
    And I should see the total "<expected_total>"

    Examples:
      | price_per_day | days | deposit | expected_subtotal | expected_total |
      | $25           | 3    | $100    | $75               | $175           |
      | $40           | 2    | $0      | $80               | $80            |

  # AC2 — Successful deposit payment (when a deposit is required)
  @happy_path
  Scenario: Pay required deposit successfully
    Given I am a signed-in renter
    And I have an approved booking that requires a deposit of "$100"
    And I am on the payment page for that booking
    When I enter valid payment information
    And I press "Submit Payment"
    Then I should see the message "Payment succeeded"
    And I should see the payment status "succeeded"
    And a payment record should exist for this booking with type "deposit" and method "simulated"
    And the payment should have a non-empty reference code and a settled timestamp

  # AC3 — Successful rental payment
  @happy_path
  Scenario: Pay rental fee successfully (after deposit paid if required)
    Given I am a signed-in renter
    And I have an approved booking
    And the deposit for this booking has already been paid
    And I am on the payment page for that booking
    When I enter valid payment information
    And I press "Submit Payment"
    Then I should see the message "Payment succeeded"
    And I should see the payment status "succeeded"
    And a payment record should exist for this booking with type "rental" and method "simulated"
    And the payment should have a non-empty reference code and a settled timestamp

  # AC4 — Failed payment shows error and records failure
  @sad_path
  Scenario: Payment fails and renter can retry
    Given I am a signed-in renter
    And I have an approved booking
    And I am on the payment page for that booking
    When I enter invalid payment information
    And I press "Submit Payment"
    Then I should see the message "Payment failed"
    And I should remain on the payment page
    And a payment record should exist for this booking with status "failed"
    And the failed payment should not have a settled timestamp

  # AC5 — Only the booking’s renter can pay
  @authorization
  Scenario: A different signed-in user cannot pay for someone else’s booking
    Given there is an approved booking for a renter different from me
    And I am signed in as a different user
    When I try to open the payment page for that booking
    Then I should see "You are not authorized to pay for this booking."
    And no payment record should be created

  # Optional variant of AC5 covering not-signed-in access (kept separate if you want both)
  @authorization
  Scenario: A not-signed-in visitor cannot access the payment page
    Given there is an approved booking
    And I am not signed in
    When I try to open the payment page for that booking
    Then I should see "You are not authorized to pay for this booking."
    And no payment record should be created
