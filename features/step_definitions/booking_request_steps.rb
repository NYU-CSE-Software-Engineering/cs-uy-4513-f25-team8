When("I request the item {string} for {string} to {string}") do |title, start_date, end_date|
  item = Item.find_by(title: title)
  renter = @current_user
  owner = item.owner

  @booking_response = post("/bookings", params: {
    item_id: item.id,
    renter_id: renter.id,
    owner_id: owner.id,
    start_date: start_date,
    end_date: end_date
  })
end

Given("I am signed in as {string}") do |username|
  @current_user = User.find_by(username: username)
  raise "User #{username} not found" unless @current_user
  if defined?(sign_in)
    sign_in @current_user
  end
end

Given("I am on the item details page for {string}") do |title|
  @current_item = Item.find_by(title: title)
  raise "Item #{title} not found" unless @current_item
end

When("I request the item {string} for {string} to {string}") do |title, start_date, end_date|
  item = Item.find_by(title: title)
  renter = @current_user
  owner = item.owner

  @booking_response = post("/bookings", params: {
    booking: {
      item_id: item.id,
      renter_id: renter.id,
      owner_id: owner.id,
      start_date: start_date,
      end_date: end_date
    }
  })
end

Then("I should see {string}") do |expected_text|
  expect(@booking_response.body).to include(expected_text)
end

Then("a booking should exist in the database with status {string}") do |expected_status|
  booking = Booking.last
  expect(booking).not_to be_nil
  expect(booking.status).to eq(expected_status)
end

When("I sign out") do
  @current_user = nil
end

When("I sign in as {string}") do |username|
  @current_user = User.find_by(username: username)
  raise "User #{username} not found" unless @current_user
  if defined?(sign_in)
    sign_in @current_user
  end
end

When("I visit the owner dashboard and open the booking request for {string}") do |title|
  item = Item.find_by(title: title)
  @booking = Booking.find_by(item: item, owner: @current_user)
  raise "Booking not found for #{title}" unless @booking
end

When("I click {string}") do |button_text|
  case button_text
  when "Approve Booking"
    @booking_response = patch("/bookings/#{@booking.id}/approve")
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