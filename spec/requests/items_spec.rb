require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items/new" do
    it "renders the new template" do
      get "/items/new"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Item")
    end
  end
end
