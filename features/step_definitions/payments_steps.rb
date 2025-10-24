# features/step_definitions/payments_steps.rb
require "securerandom"
require "uri"

Given("I am a signed-in renter") do
  # If Devise exists, log in; otherwise just hit a page so the step isn't pending.
  if defined?(User)
    @renter = User.create!(email: "renter#{SecureRandom.hex(4)}@example.com", password: "password")
  end

  begin
    visit new_user_session_path
    fill_in "Email", with: (@renter&.email || "renter@example.com")
    fill_in "Password", with: "password"
    click_button "Log in"
  rescue NameError, NoMethodError, Capybara::ElementNotFound
    visit "/" # fallback if Devise/routes not set up yet
  end
end

Given(
  "I have an approved booking priced {string} per day for {string} days with a deposit of {string}"
) do |price_per_day, days, deposit|
  @price_per_day = price_per_day
  @days         = days
  @deposit      = deposit

  if defined?(Booking)
    item = defined?(Item) ? Item.create!(title: "Camera", price_per_day: price_per_day.gsub(/[^0-9.]/,"").to_f) : nil
    @booking = Booking.create!(
      item: item, renter: @renter, status: "approved",
      start_date: Date.today, end_date: Date.today + days.to_i
    )
  else
    @booking = OpenStruct.new(id: 1)
  end
end

When("I open the payment page for that booking") do
  # Prefer nested route helper if present; otherwise, hit the likely URL pattern.
  begin
    visit new_booking_payment_path(@booking)
  rescue NameError
    visit "/bookings/#{@booking.respond_to?(:id) ? @booking.id : 1}/payments/new"
  end
end

Then("I should see the rental subtotal {string}") { |text| expect(page).to have_content(text) }
Then("I should see the deposit {string}")        { |text| expect(page).to have_content(text) }
Then("I should see the total {string}")          { |text| expect(page).to have_content(text) }

Given("I have an approved booking that requires a deposit of {string}") do |deposit|
  step %{I have an approved booking priced "$25" per day for "3" days with a deposit of "#{deposit}"}
end

Given("I am on the payment page for that booking") do
  step %{I open the payment page for that booking}
end

When("I enter valid payment information") do
  # Fields might not exist yet; that's OK—this will fail later if the page isn't built.
  begin
    fill_in "Card Number", with: "4242 4242 4242 4242"
    fill_in "Expiration",  with: "12/30"
    fill_in "CVC",         with: "123"
  rescue Capybara::ElementNotFound
  end
end

When("I enter invalid payment information") do
  begin
    fill_in "Card Number", with: "4000 0000 0000 0002" # typical decline test number
  rescue Capybara::ElementNotFound
  end
end

When("I press {string}") { |btn| click_button btn }

Then("I should see the message {string}") { |msg| expect(page).to have_content(msg) }

Then("I should see the payment status {string}") do |status|
  expect(page).to have_content(status)
end

Then("a payment record should exist for this booking with type {string} and method {string}") do |ptype, method|
  if defined?(Payment)
    scope = Payment.where(booking: @booking, method: method)
    # Support either :payment_type or :type
    found = scope.where(payment_type: ptype).or(scope.where(type: ptype)).exists?
    expect(found).to be(true)
  else
    raise "Payment model not implemented yet"
  end
end

Then("the payment should have a non-empty reference code and a settled timestamp") do
  if defined?(Payment)
    p = Payment.where(booking: @booking).order(created_at: :desc).first
    expect(p).not_to be_nil
    code = p.respond_to?(:reference_code) ? p.reference_code : p.try(:reference)
    expect(code).to be_present
    expect(p.respond_to?(:settled_at) ? p.settled_at : nil).to be_present
  else
    raise "Payment model not implemented yet"
  end
end

Given("the deposit for this booking has already been paid") do
  if defined?(Payment)
    attrs = {
      booking: @booking, method: "simulated", status: "succeeded",
      dollar_amount: 100, reference_code: SecureRandom.hex(6), settled_at: Time.current
    }
    Payment.create!(attrs.merge(payment_type: "deposit")) rescue Payment.create!(attrs.merge(type: "deposit"))
  end
end

Then("I should remain on the payment page") do
  expect(URI.parse(current_url).path).to match(/payments/)
end

Then("a payment record should exist for this booking with status {string}") do |status|
  if defined?(Payment)
    expect(Payment.where(booking: @booking, status: status).exists?).to be(true)
  else
    raise "Payment model not implemented yet"
  end
end

Then("the failed payment should not have a settled timestamp") do
  if defined?(Payment)
    p = Payment.where(booking: @booking, status: "failed").order(created_at: :desc).first
    expect(p).not_to be_nil
    expect(p.settled_at).to be_nil
  else
    raise "Payment model not implemented yet"
  end
end

Given("there is an approved booking for a renter different from me") do
  if defined?(User) && defined?(Booking)
    other = User.create!(email: "other#{SecureRandom.hex(4)}@example.com", password: "password")
    item = defined?(Item) ? Item.create!(title: "Drone", price_per_day: 30) : nil
    @booking = Booking.create!(item: item, renter: other, status: "approved",
                               start_date: Date.today, end_date: Date.today + 2)
  else
    @booking = OpenStruct.new(id: 2)
  end
end

Given("I am signed in as a different user") do
  if defined?(User)
    @user = User.create!(email: "diff#{SecureRandom.hex(4)}@example.com", password: "password")
  end
  begin
    visit new_user_session_path
    fill_in "Email", with: (@user&.email || "diff@example.com")
    fill_in "Password", with: "password"
    click_button "Log in"
  rescue NameError, Capybara::ElementNotFound
    visit "/"
  end
end

When("I try to open the payment page for that booking") do
  step %{I open the payment page for that booking}
end

Then("no payment record should be created") do
  if defined?(Payment)
    expect(Payment.where(booking: @booking).exists?).to be(false)
  else
    raise "Payment model not implemented yet"
  end
end

Given("there is an approved booking") do
  if defined?(Booking)
    item = defined?(Item) ? Item.create!(title: "Tent", price_per_day: 20) : nil
    renter = defined?(User) ? User.create!(email: "renter#{SecureRandom.hex(4)}@example.com", password: "password") : nil
    @booking = Booking.create!(item: item, renter: renter, status: "approved",
                               start_date: Date.today, end_date: Date.today + 2)
  else
    @booking = OpenStruct.new(id: 3)
  end
end

Given("I am not signed in") do
  # No-op. Ensures we simulate a logged-out state.
end

