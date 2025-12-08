# Admin User (Feature Design) — Item Rental SaaS

**Module:** Administrative Powers

**Author:** Sufyan Waryah 

**Date:** 10/24/2025

---

## Task 1 - User Story

As an **Admin**, I want to **view and manage all user accounts on the platform** so that I can **maintain platform security and integrity** by moderating reported or problematic users.

### Acceptance Criteria (Gherkin-ready)

| ID | Happy/Sad Path | Description                                                                                                                            |
| :--- |:---------------|:---------------------------------------------------------------------------------------------------------------------------------------|
| **AC1** | Happy          | Admin can **view all users** and their key details (username, role, report count, status) on a central dashboard.                      |
| **AC2** | Happy          | Admin can **search and filter** the user list by criteria like username or email to quickly find a specific account.                   |
| **AC3** | Sad            | Admin can successfully **disable/ban** a user's account, which sets their status to "disabled" and prevents them from logging in.      |
| **AC4** | Happy          | Admin can successfully **re-enable** a previously disabled account, setting the status back to "active" and restoring login access.    |
| **AC5** | Sad/Moderation | Admin can permanently remove an inappropriate item listing.                                                                            |
| **AC6** | Sad/Security   | **Non-Admins** (Renters/Owners) are **denied access** to the User Management Dashboard and see a denied access error.                  |

---

## Task 2 - MVC Components

### Models

| Model | Purpose                                                                                            | Attributes                                                                                                      |
| :--- |:---------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| **User** (Existing) | Source of truth for identity and authorization. The Admin feature will directly modify its status. | `role` (for authorization), `account_status` (for disable/enable, e.g., 'active' / 'disabled'), `report_count`. |
| **Dispute** (Existing) | Used to indicate *why* an Admin is reviewing a user, indirectly supporting moderation decisions.   | `status`, `created_by`, `resolved_by`.                                                                          |

### Views

| View File | Purpose | Related ACs                          |
| :--- | :--- |:-------------------------------------|
| `admin/users/index` | **User Management Dashboard.** Displays the searchable list of all users and their status. | AC1, AC2 |
| `admin/users/show` | **Admin User Profile View.** Displays a single user's detailed data and moderation controls. | AC3, AC4 |
| `items/show` | **Item Detail View.** Displays item details with a "Remove Listing" button visible to admins. | AC5 |

### Controller

| Controller/Action                   | Authorization & Function                                                                                                                             |
|:------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **`Admin::UsersController#index`**  | **Requires Admin role.** Fetches and displays all users, handling search/filtering parameters.                                                       |
| **`Admin::UsersController#show`**   | **Requires Admin role.** Fetches a single user to display their details and current status.                                                          |
| **`Admin::UsersController#update`** | **Requires Admin role.** Handles POST requests to change a user's `account_status` (e.g., from 'active' to 'disabled' or vice versa).                |
| **`Admin::ItemsController#destroy`** | **Requires Admin role.** Permanently removes an inappropriate item listing and increments the owner's report_count. |

### Routing

```ruby
# config/routes.rb
namespace :admin do
  resources :users, only: [:index, :show, :update]
  resources :items, only: [:destroy]
end