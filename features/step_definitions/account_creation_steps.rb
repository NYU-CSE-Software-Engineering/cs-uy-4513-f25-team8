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
  expect(current_path).to eq(signup_path)
end

Given('I am on the account creation form') do
  visit signup_path
end

When('I fill in {string} with {string}') do |field, value|
  case field
  when 'Username'
    fill_in 'user_username', with: value
  when 'Email'
    fill_in 'user_email', with: value
  when 'Password'
    fill_in 'user_password', with: value
  when 'Role'
    fill_in 'user_role', with: value
  else
    fill_in field, with: value
  end
end

Then('I should be where I was before clicking {string}') do |_button_text|
  expect(current_path).to eq(root_path)
end

Then('I should be signed in') do
  expect(page).not_to have_content('Sign Up')
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
