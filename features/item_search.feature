Feature: Item search and filtering
  As a signed-in renter
  I want to search and filter available rental listings
  So that I can find items that I’m looking to rent

  Background:
    Given I am a signed-in renter

  Scenario: Search by keyword displays only relevant results
    Given I am on the search page
    When I enter "camera" in the keyword field
    And I press "Search"
    Then I should see listings related to "camera"
    And I should not see listings unrelated to "camera"

  Scenario: Filter by category and date range
    Given I am on the search page
    When I select "Electronics" from the category filter
    And I choose the available dates "2025-03-10" to "2025-03-15"
    And I press "Search"
    Then I should see only listings in the "Electronics" category
    And I should see only listings available between "2025-03-10" and "2025-03-15"

  Scenario: Results show required fields
    When I search for items matching "camera"
    Then each result should display the item name
    And each result should display an image
    And each result should display the price per day
    And each result should display the owner name
    And each result should display the availability window

  Scenario: No results message appears for unmatched searches
    Given I am on the search page
    When I enter a keyword with no matching listings in the keyword field
    And I press "Search"
    Then I should see "No items found"

  Scenario: Clicking a result opens the details page
    When I search for items matching "camera"
    And I click on a result listing
    Then I should be on the item details page
    And I should see the item description
    And I should see the price per day
