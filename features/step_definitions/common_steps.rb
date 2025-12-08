# Common step definitions used across multiple features

Given('I am a signed-in renter') do
  @renter = User.find_or_create_by!(username: 'test_renter') do |user|
    user.email = 'renter@test.com'
    user.password = 'password123'
    user.role = 'renter'
    user.account_status = 'active'
  end
  @renter.update!(password: 'password123') if @renter.encrypted_password.blank?
  
  # Sign in via browser
  visit new_user_session_path
  fill_in 'Email', with: @renter.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign In'
  sleep 0.5
  
  sign_in_for_test(@renter)
  visit root_path
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

