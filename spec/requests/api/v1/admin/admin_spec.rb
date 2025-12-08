require 'rails_helper'

RSpec.describe "Api::V1::Admin::Admin", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:renter) { create(:user, :renter) }
  let(:target_user) { create(:user, :renter, username: "TestUser", account_status: "active") }

  describe "POST /api/v1/admin/ban" do
    context "when user is an admin" do
      before { sign_in admin }

      it "disables a user account" do
        post "/api/v1/admin/ban", params: { 
          account_username: target_user.username, 
          enable: false 
        }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to be true
        expect(target_user.reload.account_status).to eq("disabled")
      end

      it "enables a disabled user account" do
        target_user.update(account_status: "disabled")
        
        post "/api/v1/admin/ban", params: { 
          account_username: target_user.username, 
          enable: true 
        }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to be true
        expect(target_user.reload.account_status).to eq("active")
      end

      it "returns error if user not found" do
        post "/api/v1/admin/ban", params: { 
          account_username: "NonExistentUser", 
          enable: false 
        }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["success"]).to be false
      end
    end

    context "when user is not an admin" do
      before { sign_in renter }

      it "returns unauthorized" do
        post "/api/v1/admin/ban", params: { 
          account_username: target_user.username, 
          enable: false 
        }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is not signed in" do
      it "returns unauthorized" do
        post "/api/v1/admin/ban", params: { 
          account_username: target_user.username, 
          enable: false 
        }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

