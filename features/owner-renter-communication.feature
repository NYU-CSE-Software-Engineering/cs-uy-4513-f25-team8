Feature: Renter and Owner Messaging
  As a signed-in renter
  I want to communicate securely with an owner via messaging
  So that I can organize renting their item, ask questions, and coordinate pickup details.

  Background:
    Given there is a registered renter account
    And there is a registered owner account
    And the owner has an available item listed
    And I am signed in as the renter

  Scenario: Renter starts a new chat with the owner (happy path)
    Given I am viewing the details page of an available item
    When I click on "Message Owner"
    And I type "Hi! Is this camera available next weekend?"
    And I press "Send"
    Then I should see my message appear in the chat window
    And the owner should receive a notification of a new message

  Scenario: Owner responds to renter’s message
    Given I am signed in as the owner
    And I have received a new message from a renter
    When I open the conversation
    And I type "Yes, it’s available for those dates."
    And I press "Send"
    Then the renter should see my reply in their chat history

  Scenario: Renter revisits the conversation later
    Given I am signed in as the renter
    And I have an ongoing chat with an owner
    When I return to the messaging page for that item
    Then I should see all previous messages in the correct order

  Scenario: Message cannot be sent without content (failure case)
    Given I am signed in as the renter
    And I have opened a chat with the owner
    When I press "Send" without entering a message
    Then I should see an error message saying "Message cannot be blank."
