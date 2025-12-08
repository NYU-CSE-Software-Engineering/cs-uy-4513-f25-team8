When('I click on the {string} link') do |link_text|
  click_link link_text
end

Then('I should be on the login page') do
  expect(page.current_path).to eq(new_user_session_path)
end

Then('I should not see the {string} link') do |link_text|
  expect(page).to have_no_link(link_text)
end

Then('I should not be signed in') do
  expect(page).to have_no_selector("a[data-method='delete']", text: "Logout")
  expect(page).to have_current_path(new_user_session_path).or eq(root_path)
end

When('I attempt to visit {string}') do |path|
  visit path
end
