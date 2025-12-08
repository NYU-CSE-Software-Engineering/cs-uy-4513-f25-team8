Feature: Item upload
  As an Item Owner
  I want to create a new item listing with a photo
  So that renters can discover and book my item

  Background:
    Given I am signed in as an item owner
    And I am on the new item page

  Scenario: Create item successfully with image
    When I fill in "Title" with "Camera"
    And I fill in "Price per day" with "25.00"
    And I select "Electronics" from "Category"
    And I fill in "Description" with "DSLR kit"
    And I select "available" from "Availability"
    And I attach the file "spec/fixtures/files/camera.jpg" to "Item image"
    And I press "Create Item"
    Then I should see "Item was successfully created"
    And I should be on the created item's show page
    And I should see "Camera"

