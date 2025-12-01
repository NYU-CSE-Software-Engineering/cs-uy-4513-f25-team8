require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items/new" do
    it "renders the new template" do
      get "/items/new"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Item")
    end
  end

  describe "POST /items" do
    it "creates an item and redirects to the show page" do
      owner = User.create!(username: "owner1", email: "o@example.com", role: "owner", password: "password123")

      post "/items", params: {
        item: { title: "Camera", price: 25, description: "DSLR" },
        user_id: owner.id
      }

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include("Camera")
    end
  end
end
