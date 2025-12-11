# 📦 Rent It! – Item Rental SaaS Platform

## 📌 Project Overview
**Rent It!** is a Ruby on Rails–powered Software-as-a-Service (SaaS) platform that enables users to rent everyday items from one another through a secure, centralized marketplace.

Owners can list items such as cameras, bicycles, camping gear, and equipment; renters can browse listings, negotiate, request bookings, sign agreements, and manage their rentals.  
Both parties can report scams or suspicious activity, which administrators review to ensure platform safety and integrity.

[App Link (Hosted on Heroku)](https://rent-it-app-b1355577765e.herokuapp.com/)

This project was developed for:

**Course:** CS-UY 4513 – Software Engineering  
**Professor:** Dr. DePasquale

---

## 👨‍💻 Team Lead
- Sufyan Waryah
## 👥 Developers
- Erfu Hai
- Kyle Jia
- Isabelle Larson
- Lily McAmis
- Jing Qian

---

## 🚀 Features

### User & Identity Management
- Secure registration and login
- Role-based access control (Renter, Owner, Admin)
- Admin role-switching capability

### Listings & Search
- Owners can list items with images, descriptions, and pricing
- Renters can browse and filter items

### Booking & Agreements
- Booking requests and approvals
- Automated rental agreement generation
- Rental lifecycle tracking (requested → approved → active → returned/cancelled)

### Messaging & Notifications
- Owner ⇄ Renter messaging
- Admin review notifications
- Dispute reporting and status updates

### Admin & Reporting
- User moderation
- Listing/report oversight
- System analytics and dispute dashboards

---

## 🛠️ Tech Stack

- **Language:** Ruby 3.4.7
- **Framework:** Ruby on Rails 8.1
- **Database:** PostgreSQL
- **Testing:** RSpec, Cucumber, Capybara

---

## 🏗️ Project Modules

1. **User & Identity Management** – authentication, roles, profiles
2. **Listings & Search** – item listings, categories, filters
3. **Booking & Agreements** – requests, approvals, agreements
4. **Messaging & Notifications** – conversations, alerts, disputes
5. **Admin & Reporting** – moderation tools, system metrics

---

## 📡 API Overview
Each module exposes a RESTful API for inter-module communication and external integration.

### 🎒 Items
- **GET /items** — Show all item listings
- **POST /items** — Create a new item listing as a lender
- **GET /items/:id** — Show item details
- **PATCH /items/:id** — Update an item
- **DELETE /items/:id** — Delete an item
- **DELETE /admin/items/:id** — Admin force-delete an item

### 🤝 Bookings & Payments
- **POST /bookings** — Create a booking request
- **PATCH /bookings/:id/approve** — Approve a booking as lender
- **PATCH /bookings/:id/decline** — Decline a booking as lender
- **POST /bookings/:booking_id/payments** — Process a payment for a booking <!-- do we have payments working? -->

### 💬 Contacts
- **POST /contacts** — Submit a contact form inquiry

### Disputes
- **POST /api/v1/disputes** — Open a new dispute as non-admin
- **GET /api/v1/disputes/mine** — Retrieve authenticated user's disputes

### Admin API
- **POST /api/v1/admin/ban** — Ban a user account
- **POST /api/v1/admin/disputes/new** — Create a dispute as admin
- **GET /api/v1/admin/disputes** — List all system disputes
- **PATCH /api/v1/admin/disputes/:id/resolve** — Resolve a specific dispute


## Viewable Pages

These routes render HTML views for the user interface.

### 👤 User & Authentication
- **`/users/sign_in`** — Login page
- **`/users/sign_up`** — Registration page
- **`/password_reset`** — Custom password reset (Username form)
- **`/password_reset/questions`** — Security questions form
- **`/security/verify/:id`** — Identity verification page

### 🏠 Core Application
- **`/`** — Homepage
- **`/dashboard`** — User Dashboard
- **`/items`** — Browse all items
- **`/items/:id`** — View single item details
- **`/bookings`** — View current and past bookings
- **`/contacts/new`** — Contact support/admin form

### 🛡️ Admin Panel
- **`/admin/users`** — User management list
- **`/admin/contacts`** — View contact form submissions

---

## ⚙️ Setup Instructions

These instructions will get a copy of the project up and running on your local machine.

### 1. Requirements

* **Ruby:** 3.4.7
* **Rails:** 8.1.x
* **Bundler:** (latest)
* **PostgreSQL:** 14+

### 2. Clone Repository

```
git clone git@github.com:NYU-CSE-Software-Engineering/cs-uy-4513-f25-team8.git
```

### 3. Install Dependencies

```
bundle install
```

### 4. Set Up the Database

```
rails db:create
rails db:migrate
rails db:seed
```

### 5. Run the Server

```
rails server 
```

## 🧪 Testing Instructions

### Run Automated Tests

To ensure the application is functioning correctly, use the following commands to execute the test suites:

* **Unit and Request Suite (RSpec):** Runs all standard unit and controller tests.
    ```sh
    bundle exec rspec
    ```

* **Acceptance Flows (Cucumber):** Runs behavior-driven tests focusing on high-level flows.
    ```sh
    bundle exec cucumber
    ```

### Feature Testing

To run a specific feature file explicitly (e.g., for development or CI environments):

```sh
bundle exec cucumber features/feature_name.feature
