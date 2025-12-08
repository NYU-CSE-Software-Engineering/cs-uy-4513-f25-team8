require 'rails_helper'

RSpec.describe Dispute, type: :model do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  describe "validations" do
    it "is valid with valid attributes" do
      dispute = build(:dispute, item: item, created_by: user)
      expect(dispute).to be_valid
    end

    it "requires a reason" do
      dispute = build(:dispute, item: item, created_by: user, reason: nil)
      expect(dispute).not_to be_valid
      expect(dispute.errors[:reason]).to be_present
    end

    it "requires details" do
      dispute = build(:dispute, item: item, created_by: user, details: nil)
      expect(dispute).not_to be_valid
      expect(dispute.errors[:details]).to be_present
    end

    it "requires status to be 'open' or 'resolved'" do
      dispute = build(:dispute, item: item, created_by: user, status: "invalid")
      expect(dispute).not_to be_valid
      expect(dispute.errors[:status]).to be_present
    end
  end

  describe "associations" do
    it "belongs to an item" do
      dispute = create(:dispute, item: item, created_by: user)
      expect(dispute.item).to eq(item)
    end

    it "belongs to created_by user" do
      dispute = create(:dispute, item: item, created_by: user)
      expect(dispute.created_by).to eq(user)
    end

    it "belongs to resolved_by user (optional)" do
      admin = create(:user, :admin)
      dispute = create(:dispute, :resolved, item: item, created_by: user, resolved_by: admin)
      expect(dispute.resolved_by).to eq(admin)
    end
  end

  describe "scopes" do
    it "has open scope" do
      open_dispute = create(:dispute, :open, item: item, created_by: user)
      resolved_dispute = create(:dispute, :resolved, item: item, created_by: user)
      
      expect(Dispute.open).to include(open_dispute)
      expect(Dispute.open).not_to include(resolved_dispute)
    end

    it "has resolved scope" do
      open_dispute = create(:dispute, :open, item: item, created_by: user)
      resolved_dispute = create(:dispute, :resolved, item: item, created_by: user)
      
      expect(Dispute.resolved).to include(resolved_dispute)
      expect(Dispute.resolved).not_to include(open_dispute)
    end
  end

  describe "#resolve!" do
    let(:admin) { create(:user, :admin) }
    let(:dispute) { create(:dispute, :open, item: item, created_by: user) }

    it "resolves the dispute" do
      dispute.resolve!(admin, "Resolved notes")
      expect(dispute.reload.status).to eq("resolved")
      expect(dispute.resolved_by).to eq(admin)
      expect(dispute.resolved_at).to be_present
      expect(dispute.resolution_notes).to eq("Resolved notes")
    end
  end
end

