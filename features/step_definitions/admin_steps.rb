def find_user(username)
  User.find_by!(username: username)
rescue ActiveRecord::RecordNotFound
  raise "User with username '#{username}' not found in the database."
end

# helper method to find an item in the test database
def find_item(title)
  Item.find_by!(title: title)
rescue ActiveRecord::RecordNotFound
  raise "Item with title '#{title}' not found in the database."
end

Given("the user {string} exists with role {string} and account status {string}") do |username, role, status|
  User.find_or_create_by!(username: username) do |user|
    user.role = role
    user.account_status = status
    user.email = "#{username.downcase}@example.com"
    user.password = 'password123'
  end
end

Given("I am signed in as an Admin") do
  @admin = User.find_by(role: 'admin', account_status: 'active')
  unless @admin
    @admin = User.create!(
      username: 'TestAdmin',
      email: 'admin@test.com',
      password: 'password123',
      role: 'admin',
      account_status: 'active'
    )
  end
  @admin.update!(role: 'admin', account_status: 'active', password: 'password123')

  visit new_user_session_path
  fill_in 'Email', with: @admin.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign In'

  # Wait for redirect after login
  sleep 0.5

  sign_in_for_test(@admin)
end

Given("I am signed in as a Renter") do
  @renter = User.find_by(role: 'renter')
  unless @renter
    @renter = User.create!(username: 'TestRenter', email: 'renter@test.com', password: 'password123', role: 'renter', account_status: 'active')
  end
  @renter.update!(password: 'password123') if @renter.encrypted_password.blank?

  visit new_user_session_path
  fill_in 'Email', with: @renter.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign In'

  sleep 0.5

  sign_in_for_test(@renter)
end

Given("a listing exists titled {string} owned by user {string}") do |title, owner_username|
  owner = User.find_by(username: owner_username)
  unless owner
    owner = User.create!(
      username: owner_username,
      email: "#{owner_username.downcase}@example.com",
      password: 'password123',
      role: 'owner',
      account_status: 'active'
    )
  end
  @item = Item.create!(title: title, owner_id: owner.id, price: 10, payment_methods: "credit_card", deposit_amount: 0)
end

Given("the listing {string} has been flagged for review") do |title|
  item = find_item(title)

  reporter = User.find_by(username: 'Lily') || User.create!(username: 'Lily', email: 'lily_report@test.com', password: 'password', role: 'renter')

  Dispute.create!(
    item_id: item.id,
    created_by: reporter,
    reason: 'Inappropriate content/scam',
    details: 'This listing promotes illegal activity or is a scam. Who would list a 2023 Ferrari 296 GTS for $100 a month to rent with $0 down payment????',
    status: 'open'
  )

  # Note: report_count is incremented when admin removes the listing, not when it's flagged
end

When("I visit the User Management Dashboard") do
  visit admin_users_path
end

When("I visit the Admin user profile page for {string}") do |username|
  user = find_user(username)
  visit admin_user_path(user)
end

When("I search for {string}") do |search_term|
  fill_in 'search', with: search_term
  click_button 'Search'
end

When("I click the {string} button") do |button_name|
  # Wait for page to be ready
  sleep 0.5

  begin
    click_button button_name, wait: 5
  rescue Capybara::ElementNotFound
    begin
      find("input[type='submit'][value='#{button_name}']", wait: 5).click
    rescue Capybara::ElementNotFound
      find("button", text: /#{button_name}/i, wait: 5).click
    end
  end
end

When("the user {string} attempts to sign in with valid credentials") do |username|
  user = find_user(username)
  user.update!(password: 'password123') if user.encrypted_password.blank?

  begin
    Capybara.current_session.driver.submit :delete, '/users/sign_out', {}
  rescue => e
    begin
      visit '/users/sign_out'
    rescue
    end
  end
  sleep 0.5

  visit new_user_session_path

  expect(page).to have_field('Email', wait: 5)

  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign In'
end

When("I try to visit the User Management Dashboard path") do
  visit admin_users_path
end

When("I visit the listing page for {string}") do |title|
  item = find_item(title)
  visit item_path(item)
end

Then("I should see the following user details:") do |expected_table|
  expected_table.hashes.each do |expected_row|
    expect(page).to have_content(expected_row['username'])
    # Role is displayed capitalized in the view, so use case-insensitive matching
    expect(page).to have_content(/#{expected_row['role']}/i)
    # Account status is displayed capitalized in the view, so use case-insensitive matching
    expect(page).to have_content(/#{expected_row['account_status']}/i)
    expect(page).to have_content(expected_row['report_count'])
  end
end

Then("I should see the user {string}") do |username|
  expect(page).to have_content(username)
end

Then("I should not see the user {string}") do |username|
  expect(page).to have_no_content(username)
end


Then("the user {string} should have account status {string} in the database") do |username, status|
  user = find_user(username)
  expect(user.account_status).to eq(status)
end

Then("they should see the message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see the message {string}") do |message|
  # Use case-insensitive matching and allow partial matches
  expect(page).to have_content(/#{Regexp.escape(message)}/i)
end

Then("they should be signed in successfully") do
  expect(page).to have_no_selector('form#new_user')
  expect(page).to have_content("Signed in successfully.")
end

Then("I should be on the home page") do
  expect(current_path).to eq('/')
end

Then("I should see the error message {string}") do |message|
  expect(page).to have_content(message)
end

Then("the listing {string} should not exist in the database") do |title|
  expect(Item.find_by(title: title)).to be_nil
end

Then("the user {string} should have a report_count of {int}") do |username, count|
  user = find_user(username)
  expect(user.reload.report_count).to eq(count)
end
