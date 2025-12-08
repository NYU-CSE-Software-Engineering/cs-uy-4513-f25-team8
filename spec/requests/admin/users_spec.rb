require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:renter) { create(:user, :renter) }
  let(:owner) { create(:user, :owner) }

  describe "GET /admin/users" do
    context "when user is an admin" do
      before { sign_in admin }

      it "returns a successful response" do
        get admin_users_path
        expect(response).to have_http_status(:success)
      end

      it "displays all users" do
        user1 = create(:user, :renter, username: "User1")
        user2 = create(:user, :owner, username: "User2")
        
        get admin_users_path
        expect(response.body).to include("User1")
        expect(response.body).to include("User2")
      end

      it "filters users by search term" do
        user1 = create(:user, :renter, username: "John", email: "john@example.com")
        user2 = create(:user, :owner, username: "Jane", email: "jane@example.com")
        
        get admin_users_path, params: { search: "John" }
        expect(response.body).to include("John")
        expect(response.body).not_to include("Jane")
      end
    end

    context "when user is not an admin" do
      before { sign_in renter }

      it "redirects to root with error message" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to view this page.")
      end
    end

    context "when user is not signed in" do
      it "redirects to login" do
        get admin_users_path
        # authenticate_user! should redirect to sign-in page
        expect(response).to have_http_status(:redirect)
        # Check if location includes sign_in path
        location = response.location || ''
        expect(location).to include('sign_in')
      end
    end
  end

  describe "GET /admin/users/:id" do
    let(:target_user) { create(:user, :renter, username: "TargetUser") }

    context "when user is an admin" do
      before { sign_in admin }

      it "returns a successful response" do
        get admin_user_path(target_user)
        expect(response).to have_http_status(:success)
      end

      it "displays user details" do
        get admin_user_path(target_user)
        expect(response.body).to include("TargetUser")
      end
    end

    context "when user is not an admin" do
      before { sign_in renter }

      it "redirects to root with error message" do
        get admin_user_path(target_user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/users/:id" do
    let(:target_user) { create(:user, :renter, account_status: "active") }

    context "when user is an admin" do
      before { sign_in admin }

      it "disables a user account" do
        patch admin_user_path(target_user), params: { account_status: "disabled" }
        expect(target_user.reload.account_status).to eq("disabled")
        expect(response).to redirect_to(admin_user_path(target_user))
      end

      it "enables a disabled user account" do
        target_user.update(account_status: "disabled")
        patch admin_user_path(target_user), params: { account_status: "active" }
        expect(target_user.reload.account_status).to eq("active")
        expect(response).to redirect_to(admin_user_path(target_user))
      end
    end

    context "when user is not an admin" do
      before { sign_in renter }

      it "redirects to root" do
        patch admin_user_path(target_user), params: { account_status: "disabled" }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

