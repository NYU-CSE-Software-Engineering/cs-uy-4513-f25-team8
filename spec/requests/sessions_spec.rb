# spec/requests/sessions_spec.rb
require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "renders the login page with expected fields" do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Welcome Back")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end
  end

  describe "POST /users/sign_in" do
    it "redirects to dashboard after successful login" do
      # Create a user Devise can authenticate
      user = User.create!(
        username: "isabelle",
        email: "isabelle@example.com",
        role: "renter",
        password: "Password123!",
        password_confirmation: "Password123!"
      )

      # Devise login POST
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "Password123!"
        }
      }

      # Devise successful sign-in redirects by default
      expect(response).to redirect_to(root_path)
      follow_redirect!

      # UI expectations - check for home page content
      expect(response.body).to include("Welcome to Rent It!")
    end
  end
  
end

