require 'capybara/cucumber'

Given('I am a new user') do
  expect(page).to have_content('Sign Up')
end

Given('I am on any page with a {string} button') do |button_text|
  # / should always have a sign up button
  visit root_path
  expect(page).to have_button(button_text)
end

When('I click on the {string} button') do |button_text|
  click_button(button_text)
end

Then('I should be on the account creation form') do
  expect(current_path).to eq(signup_path)
end

Given('I am on the account creation form') do
  visit signup_path
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I press {string}') do |button_text|
  click_button(button_text)
end

Then('I should be where I was before clicking {string}') do |_button_text|
  expect(current_path).to eq(session[:return_to] || root_path)
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should be signed in') do
  # we should no longer see a sign up button
  expect(page).not_to have_content('Sign Up')
end

When('I leave {string} blank') do |field|
  fill_in field, with: ''
end

Then('I should see an error message saying the account name is invalid') do
  expect(page).to have_content('Account name is invalid')
end
