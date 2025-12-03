require 'rails_helper'

RSpec.describe "Account Creation", type: :request do
  describe "GET /signup" do
    it "renders the signup page" do
      get "/signup"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users" do
    it "creates a user and redirects to home" do
      post "/users", params: {
        user: {
          username: "lily",
          role: "renter",
          email: "lily@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Account successfully created")
    end
  end
end
