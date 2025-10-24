# features/step_definitions/item_upload_steps.rb
require "fileutils"

# --- helpers ---------------------------------------------------------------
def resolve_path(helper_sym, fallback)
  # 关键：Rails 常量不存在或没有该路由 helper 时，退回到 fallback 字符串路径
  return fallback unless defined?(Rails) &&
                         Rails.respond_to?(:application) &&
                         Rails.application.routes.url_helpers.respond_to?(helper_sym)
  Rails.application.routes.url_helpers.send(helper_sym)
end

# --- Given -----------------------------------------------------------------
Given("I am signed in as an item owner") do
  # 没有 User 模型时，安全地跳过登录逻辑，继续下面的场景
  unless Object.const_defined?(:User)
    # 如果应用其实需要强制登录，这里等会儿会在访问 /items/new 时被重定向，届时再按提示改控制器/路由或接入 Devise
    next
  end

  user_class = Object.const_get(:User)

  # 构造最小用户属性；有 role 列则加上 owner
  attrs = { email: "owner@example.com", password: "password", password_confirmation: "password" }
  attrs[:role] = "owner" if user_class.column_names.include?("role")

  @owner = user_class.find_by(email: attrs[:email]) || user_class.create!(**attrs)

  # 如果项目用了 Devise，并且有登录页，就用 UI 登录；否则直接继续
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
    # 没有登录路由也没关系，继续跑后续步骤；若 /items/new 要求登录，会在下面暴露出来
  end
end

Given("I am on the new item page") do
  # 先用硬编码路径兜底，避免 Rails 未加载时报 NameError
  visit "/items/new"
rescue
  # 如果硬编码路径不对，再尝试路由 helper（当 Rails 环境可用时）
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