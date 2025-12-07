Given("I am on the login page") do
  visit "/users/sign_in"
end

Given("I fill in the login field {string} with {string}") do |field, value|
  # Map field names to actual form field identifiers
  field_id = case field.downcase
             when 'email'
               'email'
             when 'password'
               'password'
             else
               field.downcase
             end
  fill_in field_id, with: value
end

Then("I should see the {string} link") do |link_text|
  expect(page).to have_link(link_text)
end

Then("the page title should be {string}") do |title|
  expect(page).to have_title(title)
end
