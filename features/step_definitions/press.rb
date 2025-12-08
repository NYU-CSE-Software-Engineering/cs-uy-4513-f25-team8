When('I press {string}') do |button_text|
  # Handle button name changes
  button_text = "Sign In" if button_text == "Log in"
  button_text = "Create Listing" if button_text == "Create Item"
  
  # If pressing "Create Account" on registration form, ensure role is selected
  if button_text == "Create Account"
    begin
      # Check if we're on the registration page
      if page.has_field?('user_role', wait: false)
        role_field = find_field('user_role')
        if role_field.value.blank?
          # Select default role "renter" if none selected
          select "Renter - Browse and rent items", from: 'user_role'
        end
      end
    rescue Capybara::ElementNotFound
      # Role field not found, continue
    end
  end
  
  # Try button first, then link if button not found
  begin
    click_button(button_text)
  rescue Capybara::ElementNotFound
    begin
      click_link(button_text)
    rescue Capybara::ElementNotFound
      # Try finding by value attribute for submit buttons
      find("input[type='submit'][value='#{button_text}']").click
    end
  end
end
