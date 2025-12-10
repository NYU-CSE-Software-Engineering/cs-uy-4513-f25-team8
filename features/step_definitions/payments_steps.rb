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
    owner: @owner,
    payment_methods: "credit_card",
    deposit_amount: 0
  )

  @booking = Booking.create!(
    item:       @item,
    renter:     @renter,
    owner:      @owner,
    start_date: Date.today,
    end_date:   Date.today + 3,
    status:     :approved
  )

  # Sign in as renter via browser
  visit new_user_session_path
  fill_in 'Email', with: @renter.email
  fill_in 'Password', with: 'password123'
  click_button 'Sign In'
  sleep 0.5
  
  sign_in_for_test(@renter)
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
  # Map test values to actual select option text
  option_text = case type
                when "Deposit"
                  "Deposit Only"
                when "Rental"
                  "Rental Fee Only"
                when "Full Payment", "Both"
                  "Deposit + Rental (Full Payment)"
                else
                  type
                end
  select option_text, from: "Payment Type"
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

  # The page shows "Status: succeeded" so check for "succeeded"
  expect(page).to have_content("succeeded")
end
