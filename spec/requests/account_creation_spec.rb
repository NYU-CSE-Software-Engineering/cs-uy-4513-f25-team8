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
  it "does not redirect and shows an error when username is invalid" do
    expect {
      post user_registration_path, params: {
        user: {
          username: "bad username",
          role: "renter",
          email: "valid@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    }.not_to change(User, :count) #make sure nothing was added to user.db

    expect(response).to have_http_status(:unprocessable_entity) #check that form re-rendered
    expect(response.body).to include("Username") # check that error displayed to user
    expect(response.body).to include("invalid").or include("Invalid")
  end
  it "does not redirect and shows an error when email format is invalid" do
    expect {
      post user_registration_path, params: {
        user: {
          username: "validusername",
          role: "renter",
          email: "notanemail",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    }.not_to change(User, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Email")
    expect(response.body).to include("invalid").or include("Invalid")
  end

end
