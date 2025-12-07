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
  @owner = User.find_or_create_by!(username: "owner1") do |user|
    user.email = "owner1@example.com"
    user.password = "password123"
    user.role = "owner"
    user.account_status = "active"
  end
  @owner.update!(password: "password123") if @owner.encrypted_password.blank?

  # Sign in via the browser
  visit new_user_session_path
  fill_in 'Email', with: @owner.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
  
  sleep 0.5
  
  sign_in_for_test(@owner)
end




Given("I am on the new item page") do

  visit "/items/new"
rescue

  visit resolve_path(:new_item_path, "/items/new")
end

# --- When ------------------------------------------------------------------


When('I select {string} from {string}') do |option, label|
  select(option, from: label)
end

When('I attach the file {string} to {string}') do |rel_path, label|
  full = Rails.root.join(rel_path)
  FileUtils.mkdir_p(File.dirname(full))
  File.write(full, "fake image bytes") unless File.exist?(full)  # placeholder so the path exists
  attach_file(label, full)
end

# --- Then ------------------------------------------------------------------
Then("I should be on the created item's show page") do
  # Works for /items/123 or similar
  expect(page).to have_current_path(%r{\A/items/\d+\z}, ignore_query: true)
end

Then("I should remain on the new item page") do
  expect(page).to have_current_path(%r{\A/items/new\z}, ignore_query: true)
end
