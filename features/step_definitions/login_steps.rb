Given("I am on the login page") do
  visit "/login"
end

Given("I fill in the login field {string} with {string}") do |field, value|
  fill_in field, with: value
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should see the {string} link") do |link_text|
  expect(page).to have_link(link_text)
end

Then("the page title should be {string}") do |title|
  expect(page).to have_title(title)
end
