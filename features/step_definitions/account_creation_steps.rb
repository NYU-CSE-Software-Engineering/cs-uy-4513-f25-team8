require 'capybara/cucumber'

Given('I am a new user') do
  expect(page).to have_content('Sign Up')
end

Given('I am on any page with a {string} button') do |button_text|
  visit root_path
  expect(page).to have_button(button_text)
end

When('I click on the {string} button') do |button_text|
  click_button(button_text)
  follow_redirect! if page.driver.respond_to?(:follow_redirect!)
end

Then('I should be on the account creation form') do
  expect(current_path).to eq(new_user_registration_path)
end

Given('I am on the account creation form') do
  visit new_user_registration_path
end

When('I fill in {string} with {string}') do |field, value|
  case field
  when 'Username'
    fill_in 'user_username', with: value
  when 'Email'
    fill_in 'user_email', with: value
  when 'Password'
    fill_in 'user_password', with: value
    # Devise requires password_confirmation, so fill it automatically
    fill_in 'user_password_confirmation', with: value
  when 'Role'
    fill_in 'user_role', with: value
  when 'Title'
    fill_in 'item_title', with: value
  when 'Price per day'
    fill_in 'item_price', with: value
  when 'Description'
    fill_in 'item_description', with: value
  else
    begin
      fill_in field, with: value
    rescue Capybara::ElementNotFound
      # Try to find by label text
      find("label", text: field).click
      fill_in find("label", text: field)[:for], with: value
    end
  end
end

Then('I should be where I was before clicking {string}') do |_button_text|
  expect(current_path).to eq(root_path)
end

Then('I should be signed in') do
  # After account creation, verify the user was created and session is set
  # Check that we're on the home page (not signup page) and success message is shown
  expect(current_path).to eq(root_path)
  expect(page).to have_content('Account successfully created')
  
  # Verify user exists in database
  user = User.find_by(email: 'new_user@example.com')
  expect(user).not_to be_nil
  
  # Check that the Sign Up button (from layout) is not visible
  # Note: The home page has "Sign Up" as text, so we check for the button specifically
  expect(page).not_to have_button('Sign Up')
end

When('I leave {string} blank') do |field|
  case field
  when 'Username'
    fill_in 'user_username', with: ''
  when 'Email'
    fill_in 'user_email', with: ''
  when 'Password'
    fill_in 'user_password', with: ''
  when 'Role'
    fill_in 'user_role', with: ''
  else
    fill_in field, with: ''
  end
end

Then('I should see an error message saying the account name is invalid') do
  expect(page).to have_content('Account name is invalid')
end
