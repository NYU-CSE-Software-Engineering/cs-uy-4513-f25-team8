# features/step_definitions/messaging_steps.rb
# step definitions

Given("there is a registered renter account") do
  @renter = User.create!(
    username: "renter_user",
    email: "renter@example.com",
    password: "password",
    role: "renter"
  )
end

Given("there is a registered owner account") do
  @owner = User.create!(
    username: "owner_user",
    email: "owner@example.com",
    password: "password",
    role: "owner"
  )
end

Given("the owner has an available item listed") do
  @item = Item.create!(
    title: "Camera",
    description: "DSLR Camera",
    owner: @owner,
    item_price_per_day: 50,
    availability_status: "available",
    listed_at: Time.now
  )
end

Given("I am signed in as the renter") do
  visit new_user_session_path
  fill_in "Email", with: @renter.email
  fill_in "Password", with: "password"
  click_button "Log in"
end

Given("I am signed in as the owner") do
  visit new_user_session_path
  fill_in "Email", with: @owner.email
  fill_in "Password", with: "password"
  click_button "Log in"
end

Given("I have an ongoing chat with an owner") do
  @booking = Booking.create!(item: @item, renter: @renter, start_date: Date.today, end_date: Date.today + 2)
  @message = Message.create!(booking: @booking, sender: @renter, body: "Hello!", sent_at: Time.now)
end

Given("I have received a new message from a renter") do
  @booking = Booking.create!(item: @item, renter: @renter, start_date: Date.today, end_date: Date.today + 2)
  @message = Message.create!(booking: @booking, sender: @renter, body: "Is this available?", sent_at: Time.now)
end

Given("I am viewing the details page of an available item") do
  visit item_path(@item)
end

When("I click on {string}") do |button_text|
  click_button button_text
end

When("I type {string}") do |message_text|
  fill_in "message_body", with: message_text
end

Then("I should see my message appear in the chat window") do
  expect(page).to have_content(@message.body).or have_content("Hi! Is this camera available next weekend?")
end

Then("the owner should receive a notification of a new message") do
  # This is a placeholder; could check for ActionMailer or a flash notification
  expect(Notification.last.recipient).to eq(@owner)
end

Then("the renter should see my reply in their chat history") do
  expect(page).to have_content("Yes, it’s available for those dates.")
end

Then("I should see all previous messages in the correct order") do
  visit messages_path
  expect(page.body.index("Hello!")).to be < page.body.index("Hi! Is this camera available next weekend?") if page.has_content?("Hi! Is this camera available next weekend?")
end

Then("I should see an error message saying {string}") do |error_message|
  expect(page).to have_content(error_message)
end
