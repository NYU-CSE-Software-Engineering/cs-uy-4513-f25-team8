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
end

