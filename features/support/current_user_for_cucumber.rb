# features/support/current_user_for_cucumber.rb
# This file is loaded ONLY in Cucumber, not in RSpec.
# For Cucumber scenarios we always treat the test renter
# (email: renter@example.com) as the logged-in user.

class ApplicationController < ActionController::Base
  def current_user
    User.find_by(email: "renter@example.com")
  end
end
