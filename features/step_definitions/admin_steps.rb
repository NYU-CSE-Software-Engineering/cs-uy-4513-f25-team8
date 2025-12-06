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
  @admin = User.find_by(role: 'admin')
  unless @admin
    @admin = User.create!(username: 'TestAdmin', email: 'admin@test.com', password: 'password', role: 'admin', account_status: 'active')
  end
  visit new_user_session_path
  fill_in 'Email', with: @admin.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Given("I am signed in as a Renter") do
  @renter = User.find_by(role: 'renter')
  unless @renter
    @renter = User.create!(username: 'TestRenter', email: 'renter@test.com', password: 'password', role: 'renter', account_status: 'active')
  end
  visit new_user_session_path
  fill_in 'Email', with: @renter.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Given("a listing exists titled {string} owned by user {string}") do |title, owner_username|
  owner = find_user(owner_username)
  @item = Item.create!(title: title, owner_id: owner.id, price_per_day: 10)
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

  owner = item.owner
  owner.increment!(:report_count)
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
  click_button button_name
end

When("the user {string} attempts to sign in with valid credentials") do |username|
  user = find_user(username)
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
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
    expect(page).to have_content(expected_row['role'])
    expect(page).to have_content(expected_row['account_status'])
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

Then("the user {string} should receive a notification that their listing was removed") do |username|
  user = find_user(username)
  expect(user.notifications.where(message: /was removed/).count).to be >= 1
end

Then("the user {string} should have a report_count of {int}") do |username, count|
  user = find_user(username)
  expect(user.reload.report_count).to eq(count)
end
