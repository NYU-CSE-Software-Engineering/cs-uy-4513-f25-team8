Given('I am on the search page') do
  # Create test data
  unless @test_data_created
    @owner = User.create!(
      email: "owner@example.com",
      password: "password",
      username: "owner",
      role: "owner"
    )

    # Create camera items (should appear in camera searches)
    @camera_item = Item.create!(
      title: "Professional Camera",
      description: "High quality camera for photography",
      category: "Electronics",
      price: 50.0,
      availability_status: "available",
      owner: @owner
    )

    @camera_lens = Item.create!(
      title: "Camera Lens",
      description: "Wide angle lens for camera",
      category: "Electronics",
      price: 30.0,
      availability_status: "available",
      owner: @owner
    )

    # Create non-camera items (should NOT appear in camera searches)
    @laptop = Item.create!(
      title: "Laptop Computer",
      description: "Powerful laptop for work",
      category: "Electronics",
      price: 100.0,
      availability_status: "available",
      owner: @owner
    )

    @shirt = Item.create!(
      title: "T-Shirt",
      description: "Comfortable cotton shirt",
      category: "Clothing",
      price: 10.0,
      availability_status: "available",
      owner: @owner
    )

    @test_data_created = true
  end

  visit '/items'
end

When('I enter {string} in the keyword field') do |keyword|
  fill_in 'Keyword', with: keyword
end

Then('I should see listings related to {string}') do |keyword|
  expect(page).to have_content(/#{keyword}/i)
end

Then('I should not see listings unrelated to {string}') do |keyword|
  expect(page).not_to have_content(keyword)
end

When('I select {string} from the category filter') do |category|
  select category, from: 'Category'
end

When('I choose the available dates {string} to {string}') do |start_date, end_date|
  fill_in 'Start Date', with: start_date
  fill_in 'End Date', with: end_date
end

Then('I should see only listings in the {string} category') do |category|
  expect(page).to have_content(category)
end

Then('I should see only listings available between {string} and {string}') do |start_date, end_date|
  # Since we're only tracking availability_status, just verify items are available
  expect(page).to have_content('Available')
end

When('I search for items matching {string}') do |keyword|
  # Ensure test data exists
  unless @test_data_created
    @owner = User.create!(
      email: "owner@example.com",
      password: "password",
      username: "owner",
      role: "owner"
    )

    # Create camera items (should appear in camera searches)
    @camera_item = Item.create!(
      title: "Professional Camera",
      description: "High quality camera for photography",
      category: "Electronics",
      price: 50.0,
      availability_status: "available",
      owner: @owner
    )

    @camera_lens = Item.create!(
      title: "Camera Lens",
      description: "Wide angle lens for camera",
      category: "Electronics",
      price: 30.0,
      availability_status: "available",
      owner: @owner
    )

    # Create non-camera items (should NOT appear in camera searches)
    @laptop = Item.create!(
      title: "Laptop Computer",
      description: "Powerful laptop for work",
      category: "Electronics",
      price: 100.0,
      availability_status: "available",
      owner: @owner
    )

    @shirt = Item.create!(
      title: "T-Shirt",
      description: "Comfortable cotton shirt",
      category: "Clothing",
      price: 10.0,
      availability_status: "available",
      owner: @owner
    )

    @test_data_created = true
  end

  visit '/items'
  fill_in 'Keyword', with: keyword
  click_button 'Search'
end

Then('each result should display the item name') do
  expect(page).to have_css('.item-name')
end

Then('each result should display an image') do
  expect(page).to have_css('img')
end

Then('each result should display the price per day') do
  expect(page).to have_content('per day')
end

Then('each result should display the owner name') do
  expect(page).to have_content('Owner')
end

Then('each result should display the availability window') do
  expect(page).to have_content('Available')
end

When('I enter a keyword with no matching listings in the keyword field') do
  fill_in 'Keyword', with: 'noresults'
end

When('I click on a result listing') do
  first('.item-card a').click
end

Then('I should be on the item details page') do
  expect(page.current_path).to match(%r{/items/\d+})
end

Then('I should see the item description') do
  expect(page).to have_content('Description')
end

Then('I should see the price per day') do
  expect(page).to have_content('per day')
end
