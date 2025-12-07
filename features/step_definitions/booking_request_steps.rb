Given("the following users exist:") do |table|
  table.hashes.each do |user_attrs|
    user = User.find_or_initialize_by(username: user_attrs["username"])
    user.email = user_attrs["email"]
    user.role = user_attrs["role"]
    user.password = user_attrs["password"] || 'password123'
    user.account_status = user_attrs["account_status"] || 'active'
    user.report_count = user_attrs["report_count"].to_i if user_attrs["report_count"]
    user.save!
  end
end

Given("the following item exists:") do |table|
  table.hashes.each do |item_attrs|
    owner = User.find_by(username: item_attrs["owner"])
    Item.create!(
      title: item_attrs["title"],
      owner: owner,
      price: 25.0,
      availability_status: item_attrs["availability_status"]
    )
  end
end

Given("I am signed in as {string}") do |username|
  @current_user = User.find_by(username: username)
  raise "User #{username} not found" unless @current_user
end

When("I sign in as {string}") do |username|
  step "I am signed in as \"#{username}\""
end

When("I sign out") do
  @current_user = nil
end

Given("I am on the item details page for {string}") do |title|
  @current_item = Item.find_by(title: title)
  raise "Item #{title} not found" unless @current_item
end

When("I request the item {string} for {string} to {string}") do |title, start_date, end_date|
  item = Item.find_by(title: title)
  renter = @current_user
  owner = item.owner

  post "/bookings", params: {
    item_id: item.id,
    renter_id: renter.id,
    owner_id: owner.id,
    start_date: start_date,
    end_date: end_date
  }

  @booking = Booking.last
  expect(response.body).to include("Booking request submitted")
end

Then("a booking should exist in the database with status {string}") do |expected_status|
  booking = Booking.last
  expect(booking).not_to be_nil
  expect(booking.status).to eq(expected_status)
end

When("I visit the owner dashboard and open the booking request for {string}") do |title|
  item = Item.find_by(title: title)
  @booking = Booking.find_by(item: item, owner: @current_user)
  raise "Booking not found for #{title}" unless @booking
end

When("I click {string}") do |button_text|
  case button_text
  when "Approve Booking"
    patch "/bookings/#{@booking.id}/approve"
    @booking.reload
    expect(response.body).to include("Booking approved")
  else
    raise "Unknown button action: #{button_text}"
  end
end

Then("the booking's status should be {string}") do |expected_status|
  @booking.reload
  expect(@booking.status).to eq(expected_status)
end

Then("the renter {string} should receive a notification {string}") do |_renter, message|
  expect(message).to eq("Your booking for Camera has been approved")
end
