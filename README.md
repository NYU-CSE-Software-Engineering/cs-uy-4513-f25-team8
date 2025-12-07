# 📦 Rent It! – Item Rental SaaS Platform

## 📌 Project Overview
**Rent It!** is a Ruby on Rails–powered Software-as-a-Service (SaaS) platform that enables users to rent everyday items from one another through a secure, centralized marketplace.

Owners can list items such as cameras, bicycles, camping gear, and equipment; renters can browse listings, negotiate, request bookings, sign agreements, and manage their rentals.  
Both parties can report scams or suspicious activity, which administrators review to ensure platform safety and integrity.

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
Some core endpoints include:

# 🔧 API Overview

Each module exposes a RESTful API for identity, listings, rentals, messaging, and admin operations. Core endpoints include:

## 👤 User / Auth API
- **POST /api/v1/auth/register** — Register a new account
- **POST /api/v1/auth/login** — Log into an account
- **POST /api/v1/auth/id** — Retrieve account info via token

## 🎒 Items API
- **GET /api/v1/items/:page** — Get paginated item listings
- **GET /api/v1/items/:id** — Get detailed info about an item
- **POST /api/v1/items/new** — Create a new item listing
- **DELETE /api/v1/items/:id** — Delete an item listing

## 🤝 Lender / Booking API
- **POST /api/v1/booking/:id/rent** — Rent an item
- **POST /api/v1/booking/:id/return** — Mark an item as returned

## 💬 Messages API
- **GET /api/v1/messages/conversations/** — Get list of user conversations
- **GET /api/v1/messages/conversations/:conversationID/:page** — Get paginated messages in a conversation
- **POST /api/v1/messages/send/:conversationID** — Send a message

## 🛡️ Admin API
- **POST /api/v1/admin/ban** — Enable or disable an account
- **POST /api/v1/admin/disputes/new** — Create a dispute
- **GET /api/v1/admin/disputes** — Retrieve all disputes

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