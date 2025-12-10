require 'rails_helper'

RSpec.describe "Api::V1::Admin::Disputes", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:renter) { create(:user, :renter) }
  let(:owner) { create(:user, :owner) }
  let(:item) { create(:item, owner: owner) }

  describe "GET /api/v1/admin/disputes" do
    context "when user is an admin" do
      before { sign_in admin }

      it "returns all disputes" do
        dispute1 = create(:dispute, item: item, created_by: renter)
        dispute2 = create(:dispute, item: item, created_by: renter)
        
        get "/api/v1/admin/disputes"
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json["disputes"].length).to eq(2)
      end

      it "returns disputes in correct format" do
        dispute = create(:dispute, item: item, created_by: renter)
        
        get "/api/v1/admin/disputes"
        
        json = JSON.parse(response.body)
        dispute_data = json["disputes"].first
        expect(dispute_data).to have_key("itemID")
        expect(dispute_data).to have_key("dispute_details")
        expect(dispute_data["dispute_details"]).to have_key("reason")
        expect(dispute_data["dispute_details"]).to have_key("details")
        expect(dispute_data["dispute_details"]).to have_key("status")
      end
    end

    context "when user is not an admin" do
      before { sign_in renter }

      it "returns unauthorized" do
        get "/api/v1/admin/disputes"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/admin/disputes/new" do
    context "when user is a renter with booking" do
      let!(:booking) { create(:booking, item: item, renter: renter, owner: owner) }
      
      before do
        # Ensure booking exists before signing in
        booking
        sign_in renter
      end

      it "creates a dispute" do
        expect {
          post "/api/v1/admin/disputes/new", params: {
            itemID: item.id,
            reason: "Test reason",
            details: "Test details"
          }
        }.to change(Dispute, :count).by(1)
      end

      it "increments owner's report count" do
        expect {
          post "/api/v1/admin/disputes/new", params: {
            itemID: item.id,
            reason: "Test reason",
            details: "Test details"
          }
        }.to change { owner.reload.report_count }.by(1)
      end

      it "returns success" do
        post "/api/v1/admin/disputes/new", params: {
          itemID: item.id,
          reason: "Test reason",
          details: "Test details"
        }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to be true
      end
    end

    context "when user is an admin" do
      before { sign_in admin }

      it "creates a dispute" do
        expect {
          post "/api/v1/admin/disputes/new", params: {
            itemID: item.id,
            reason: "Test reason",
            details: "Test details"
          }
        }.to change(Dispute, :count).by(1)
      end
    end

    context "when user is not authorized" do
      let(:other_renter) { create(:user, :renter) }
      before { sign_in other_renter }

      it "returns unauthorized" do
        post "/api/v1/admin/disputes/new", params: {
          itemID: item.id,
          reason: "Test reason",
          details: "Test details"
        }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

