require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "POST /items" do
    it "creates an item and redirects to the show page" do
      user = User.create!(
        username: "owner1",
        email: "owner@example.com",
        role: "owner",
        password: "password123"
      )
      sign_in user

      post items_path, params: {
        item: { title: "Camera", price: 25, description: "DSLR" }
      }

      item = Item.last
      expect(response).to redirect_to(item_path(item))
      follow_redirect!
      expect(response.body).to include("Camera")
    end
  end
end
