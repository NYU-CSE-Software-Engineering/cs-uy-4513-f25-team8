require 'rails_helper'

RSpec.describe "Api::V1::Disputes", type: :request do
  let(:owner) { create(:user, :owner) }
  let(:renter) { create(:user, :renter) }
  let(:item) { create(:item, owner: owner) }

  describe "POST /api/v1/disputes" do
    let!(:booking) { create(:booking, item: item, renter: renter, owner: owner) }

    context "when user is authorized renter" do
      before { sign_in renter }

      it "creates a dispute with the provided reason" do
        expect {
          post "/api/v1/disputes", params: {
            itemID: item.id,
            reason: "Suspicious activity",
            details: "Item never arrived"
          }
        }.to change(Dispute, :count).by(1)

        dispute = Dispute.last
        expect(dispute.reason).to eq("Suspicious activity")
      end

      it "increments the owner's report count" do
        expect {
          post "/api/v1/disputes", params: {
            itemID: item.id,
            reason: "Damaged",
            details: "Broken lens"
          }
        }.to change { owner.reload.report_count }.by(1)
      end

      it "does not allow duplicate reports for the same item by the same user" do
        post "/api/v1/disputes", params: {
          itemID: item.id,
          reason: "Damaged",
          details: "Broken lens"
        }

        post "/api/v1/disputes", params: {
          itemID: item.id,
          reason: "Damaged again",
          details: "Duplicate attempt"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
        expect(json["error"]).to match(/already reported/i)
      end
    end

    context "when user is not signed in" do
      it "returns unauthorized" do
        post "/api/v1/disputes", params: { itemID: item.id, reason: "Test", details: "Test" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/disputes/mine" do
    let!(:user_dispute) { create(:dispute, item: item, created_by: renter, reason: "Spam", details: "Details") }
    let!(:other_dispute) { create(:dispute, item: item, reason: "Other", details: "Other", created_by: owner) }

    before { sign_in renter }

    it "returns only disputes created by the current user with statuses" do
      get "/api/v1/disputes/mine"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["disputes"].length).to eq(1)
      payload = json["disputes"].first
      expect(payload["id"]).to eq(user_dispute.id)
      expect(payload["status"]).to eq(user_dispute.status)
    end
  end
end

