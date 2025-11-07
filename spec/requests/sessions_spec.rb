# spec/requests/sessions_spec.rb
require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page with expected fields" do
      get "/login"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log in")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end
  end
  
  describe "POST /login" do
    it "redirects to dashboard and shows expected UI" do
      post "/login", params: { email: "Kyle.jia@nyu.edu", password: "Team8IsTheBest123!" }
      expect(response).to redirect_to("/dashboard")
      follow_redirect!
      expect(response.body).to include("Welcome back!")
      expect(response.body).to include("Dashboard")
      expect(response.body).to include("User Dashboard")
    end
  end

  
end

