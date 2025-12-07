require 'rails_helper'

RSpec.describe "Admin::Items", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:renter) { create(:user, :renter) }
  let(:owner) { create(:user, :owner) }
  let(:item) { create(:item, owner: owner, title: "Test Item") }

  describe "DELETE /admin/items/:id" do
    context "when user is an admin" do
      before do
        sign_in admin
        # Ensure item exists before test
        item
      end

      it "deletes the item" do
        item_id = item.id
        expect {
          delete admin_item_path(item_id)
        }.to change(Item, :count).by(-1)
      end

      it "increments the owner's report count" do
        expect {
          delete admin_item_path(item)
        }.to change { owner.reload.report_count }.by(1)
      end

      it "redirects with success message" do
        delete admin_item_path(item)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to include("successfully removed")
      end
    end

    context "when user is not an admin" do
      before do
        sign_in renter
        # Ensure item exists before test
        item
      end

      it "redirects to root" do
        delete admin_item_path(item.id)
        expect(response).to redirect_to(root_path)
      end

      it "does not delete the item" do
        item_id = item.id
        initial_count = Item.count
        delete admin_item_path(item_id)
        expect(Item.count).to eq(initial_count)
      end
    end
  end
end

