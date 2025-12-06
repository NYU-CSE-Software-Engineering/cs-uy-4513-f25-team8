# features/step_definitions/payments_steps.rb


Given("a signed-in renter with an approved booking") do
  # --- Create renter and owner ---
  @renter = User.create!(
    username: "renter_user",
    role:     "renter",
    email:    "renter@example.com",
    password: "password123"
  )

  @owner = User.create!(
    username: "owner_user",
    role:     "owner",
    email:    "owner@example.com",
    password: "password123"
  )

  # --- Create item and booking ---
  @item = Item.create!(
    title: "Camera",
    price: 50.0,
    owner: @owner
  )

  @booking = Booking.create!(
    item:       @item,
    renter:     @renter,
    owner:      @owner,
    start_date: Date.today,
    end_date:   Date.today + 3
  )

  # No explicit login needed here:
  # current_user is overridden in Cucumber to be the renter
end

When("I visit the payment page for that booking") do
  visit new_booking_payment_path(@booking)
end

Then("I should see the payment breakdown") do
  expect(page).to have_content("Rental Subtotal")
  expect(page).to have_content("Deposit")
  expect(page).to have_content("Total")
end

Given("I am on the payment page for that booking") do
  visit new_booking_payment_path(@booking)
end

When("I choose {string} as the payment type") do |type|
  # Label in app/views/payments/new.html.erb must be "Payment type"
  select type, from: "Payment type"
end

When("I submit the payment form") do
  click_button "Submit Payment"
end

Then("I should see the payment success message") do
  # Verify that a payment was created
  payment = Payment.last
  expect(payment).not_to be_nil

  # Visit the receipt page for that payment
  visit booking_payment_path(payment.booking, payment)

  expect(page).to have_content("Payment succeeded")
end
