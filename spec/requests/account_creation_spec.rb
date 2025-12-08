require 'rails_helper'

RSpec.describe "Account Creation", type: :request do
  describe "GET /users/sign_up" do
    it "renders the signup page" do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create Your Account")
    end
  end

  describe "POST /users" do
    it "creates a user and redirects to root" do
      post user_registration_path, params: {
        user: {
          username: "lily",
          role: "renter",
          email: "lily@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      # Devise default redirect after sign up
      expect(response).to redirect_to(root_path)
      follow_redirect!

      # Devise flash notice - check for any success message
      expect(response.body).to match(/successfully|created|welcome/i)
    end
  end
end
