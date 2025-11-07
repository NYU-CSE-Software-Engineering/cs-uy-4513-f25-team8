Then('I should see {string}') do |message|
  expect(page).to have_content(message)
end
