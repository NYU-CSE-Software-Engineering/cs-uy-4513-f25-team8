# features/step_definitions/item_upload_steps.rb
require "fileutils"

# --- helpers ---------------------------------------------------------------
def resolve_path(helper_sym, fallback)

  return fallback unless defined?(Rails) &&
                         Rails.respond_to?(:application) &&
                         Rails.application.routes.url_helpers.respond_to?(helper_sym)
  Rails.application.routes.url_helpers.send(helper_sym)
end

# --- Given -----------------------------------------------------------------
Given("I am signed in as an item owner") do

  unless Object.const_defined?(:User)

    next
  end

  user_class = Object.const_get(:User)


  attrs = { email: "owner@example.com", password: "password", password_confirmation: "password" }
  attrs[:role] = "owner" if user_class.column_names.include?("role")

  @owner = user_class.find_by(email: attrs[:email]) || user_class.create!(**attrs)

  begin
    if Rails.application.routes.url_helpers.respond_to?(:new_user_session_path)
      visit Rails.application.routes.url_helpers.new_user_session_path
    else
      visit "/users/sign_in"
    end

    if page.has_field?("Email") && page.has_field?("Password")
      fill_in "Email", with: @owner.email
      fill_in "Password", with: "password"
      click_button(/Log in|Sign in/i)
    end
  rescue

  end
end

Given("I am on the new item page") do

  visit "/items/new"
rescue

  visit resolve_path(:new_item_path, "/items/new")
end

# --- When ------------------------------------------------------------------
When('I fill in {string} with {string}') do |label, value|
  fill_in(label, with: value)
end

When('I select {string} from {string}') do |option, label|
  select(option, from: label)
end

When('I attach the file {string} to {string}') do |rel_path, label|
  full = Rails.root.join(rel_path)
  FileUtils.mkdir_p(File.dirname(full))
  File.write(full, "fake image bytes") unless File.exist?(full)  # placeholder so the path exists
  attach_file(label, full)
end

When('I press {string}') do |btn|
  click_button(btn)
end

# --- Then ------------------------------------------------------------------
Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then("I should be on the created item's show page") do
  # Works for /items/123 or similar
  expect(page).to have_current_path(%r{\A/items/\d+\z}, ignore_query: true)
end

Then("I should remain on the new item page") do
  expect(page).to have_current_path(%r{\A/items/new\z}, ignore_query: true)
end
