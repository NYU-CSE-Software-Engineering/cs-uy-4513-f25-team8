# Payments (Feature Design) — Item Rental SaaS

**Module:** Booking & Agreements ⇄ Payments  
**Author:** Kyle  
**Task 1 & 2 Combined Deliverable**

---

## Task 1 — User Story

**User Story**  
As a **renter**, I want to **pay securely for my approved booking** (deposit if required and the rental fee) **so that my rental is confirmed and the payment is recorded** for the owner and system.

---

### **Business Assumptions**

- Payments are recorded with:  
  `booking_id`, `payer_id`, `payee_id`, `dollar_amount`, `type` (`deposit` / `rental` / `adjustment` / `refund`),  
  `method` (`simulated`), `status` (`pending` / `succeeded` / `failed` / `refunded`),  
  `created_at`, `settled_at`, `reference_code`.

- Renter is required to pay the rental fee and deposit (if set by the owner).

- Payment interaction is simulated in tests (no real gateway), but behavior must reflect real flows (`pending → success/failure`, refundable).

---

### **Acceptance Criteria (Gherkin-ready)**

Each criterion is intentionally specific and testable; these will become scenarios in `features/payments.feature`.

---

#### **AC1 — Show accurate amount breakdown before paying**

**Given** I am a signed-in renter with an approved booking for an item priced at `$P/day` for `D` days, and the item requires a deposit of `$Z` (or `$0` if none)  
**When** I open the payment page for that booking  
**Then** I see a breakdown showing **Rental Subtotal = P × D**, **Deposit = Z**, and **Total = (P × D) + Z**, and the numbers match the booking and item data.

---

#### **AC2 — Successful deposit payment (when a deposit is required)**

**Given** my booking requires a deposit and I am on the payment page  
**When** I submit valid payment details  
**Then** the system creates a Payment linked to my booking with `type: "deposit"`, `status: "pending"`, `method: "simulated"`  
**And** the status changes to `"succeeded"`, a non-empty `reference_code` is stored, and `settled_at` is set  
**And** I see **“Payment succeeded”** and the UI reflects the deposit-paid state.

---

#### **AC3 — Successful rental payment**

**Given** my booking is approved and (if applicable) the deposit has already been paid  
**When** I submit valid payment details for the rental fee  
**Then** the system creates a Payment linked to my booking with `type: "rental"`, `status: "pending"`, `method: "simulated"`  
**And** the status changes to `"succeeded"`, a `reference_code` is stored, and `settled_at` is set  
**And** I see **“Payment succeeded”** and the UI reflects the rental-paid state.

---

#### **AC4 — Failed payment shows error and records failure**

**Given** I am on the payment page  
**When** I submit invalid or declined payment details  
**Then** a Payment record is created or updated with `status: "failed"` (and no `settled_at`)  
**And** I see **“Payment failed”** with a reason  
**And** I remain on a page where I can retry payment.

---

#### **AC5 — Only the booking’s renter can pay**

**Given** I am not the renter for the booking (e.g., a different signed-in user or not signed in)  
**When** I attempt to access the payment page or submit a payment for that booking  
**Then** I see **“You are not authorized to pay for this booking.”**  
**And** no Payment is created or modified.

---

### **Notes for Step Design (non-binding)**

- Use `status` transitions (`pending → succeeded / failed`) and persist `reference_code` & `settled_at` on success to mirror real processors.  
- Treat the `method` as `"simulated"` for all tests.  
- If an item has no deposit, AC2 is skipped; AC1/AC3/AC4/AC5 still apply.

---

## Task 2 — MVC Components

### **Models**

**Payment**

- **Attributes** (from project spec):  
  `payment_id`, `booking_id` (FK), `payer_id` (FK users), `payee_id` (FK users),  
  `dollar_amount`, `type` (`deposit` / `rental` / `adjustment` / `refund`),  
  `method` (`simulated`), `status` (`pending` / `succeeded` / `failed` / `refunded`),  
  `created_at`, `settled_at`, `reference_code`.

- **Associations:**  
  `belongs_to :booking`  
  `belongs_to :payer, class_name: "User"`  
  `belongs_to :payee, class_name: "User"`

- **Validations / Rules:**  
  Presence of `booking_id`, `payer_id`, `payee_id`, `dollar_amount`, `type`, `status`;  
  `dollar_amount > 0`;  
  Enumerations for `type` and `status`;  
  `reference_code` and `settled_at` required only on succeeded payments.

- **Behavior:**  
  Status transitions `pending → succeeded/failed/refunded`;  
  Generate `reference_code` on success;  
  Set `settled_at` on success;  
  Default `method = "simulated"`.

---

**Booking (existing)**

- **Purpose:** Source of truth for who can pay and how much to pay (dates, price, deposit flag/amount), and for allowed states (`requested/approved/active/returned/cancelled`).  
- **Associations:** `has_many :payments`  
- **Notes:** Only the renter on the booking can initiate deposit/rental payments; owners receive funds. (Spec requires renter to pay rental fee and deposit if set.)

---

**User (existing)**

- **Purpose:** Handles authorization and role checks (`renter`, `owner`, `admin`) for who may initiate or view payments.

---

### **Views**

**`payments/new`**  
- Shows item, booking dates, and **amount breakdown** (rental subtotal, deposit if required, and total).  
- Collects simulated payment input (e.g., fake card fields).  
- Matches **AC1** requirements.

**`payments/show`**  
- Displays **payment status** (`succeeded` / `failed`), `reference_code`, and timestamps.  
- Shows retry button on failure.

---

### **Controllers**

**PaymentsController**

- **`new`** — Renders the payment page for an approved booking; authorizes that the current user is the booking’s renter.  
- **`create`** — Validates access and amount, creates a `Payment` with `status: "pending"` and `method: "simulated"`, invokes simulated processing, updates to `succeeded` (adds `reference_code` and `settled_at`) or `failed`, and redirects to `show` with a flash message.  
- **`show`** — Displays the persisted result for Cucumber assertions.  

**Strong Params:**  
`:booking_id`, `:dollar_amount`, `:type`  
(Controller derives/guards amount and type server-side to prevent tampering.)

---

### **Routing**

Nested under bookings to keep context:

```ruby
resources :bookings, only: [] do
  resources :payments, only: [:new, :create, :show]
end
```

---

### **Notes on Roles & Authorization**

- **Renter:** May create deposit/rental payments for their own approved booking.  
- **Owner:** Receives funds (`payee_id`); may only view payments, not create them.  
- **Admin:** Read-only visibility for moderation/reporting (refunds would be a separate story).

---
