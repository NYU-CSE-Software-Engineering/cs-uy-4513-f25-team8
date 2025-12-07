# Common step definitions used across multiple features

Given('I am a signed-in renter') do
  @renter = User.find_or_create_by!(username: 'test_renter') do |user|
    user.email = 'renter@test.com'
    user.password = 'password123'
    user.role = 'renter'
    user.account_status = 'active'
  end
  
  sign_in_for_test(@renter)
  visit root_path
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

