Item Upload (Feature Design) — Item Rental SaaS
Module: Listings & Search ↔ User & Identity
 Feature Owner: Listings (Item Owner workflow)
 Scope: Web UI (Rails MVC) + optional API contract alignment

1) User Story
As an Item Owner
 I want to create a new item listing with required fields and a photo
 so that renters can discover and book my item.
2) Acceptance Criteria (Gherkin-ready)
Each AC should map 1-to-1 to a scenario in features/item_upload.feature.
AC1 — Successful creation with image
●	Given I am signed in as an Item Owner

●	And I am on the “New Item” page

●	When I fill in Title, Price per day, Category, Description, select Availability, and upload a valid image

●	And I press “Create Item”

●	Then I see “Item was successfully created”

●	And I am redirected to the item’s show page

●	And I can see the Title and the uploaded Item image

AC2 — Form validation (missing required fields)
●	Given I am signed in as an Item Owner and on the “New Item” page

●	When I submit without a Title or Price per day

●	Then I remain on the form page

●	And I see validation errors (e.g., “Title can’t be blank”, “Price per day can’t be blank”)

AC3 — Authorization (unauthenticated / non-owner)
●	Given I am not signed in (or I am signed in but not an Owner)

●	When I visit the “New Item” page or attempt to submit the form

●	Then I am asked to sign in or I see “You are not authorized to create listings.”

AC4 — Availability defaults / options
●	Given I am on the “New Item” page

●	When I do not explicitly change Availability

●	Then Availability defaults to available

●	And the form offers available, pending, unavailable as selectable states

AC5 — Image validation (type/size)
●	Given I am on the “New Item” page

●	When I upload a non-image file or an oversized image

●	Then I see a clear error (e.g., “Invalid image file”)

●	And I remain on the form to correct and resubmit

AC6 — API guardrails (optional, if testing API)
●	Given I call POST /api/v1/items/new without a valid Owner token or with disallowed parameters

●	Then I receive 401/403 or validation errors

●	And no item record is created

3) MVC Components (Outline)

Model: Item
●	Core attributes:
 owner_id:references, title:string, description:text,
 item_image:attachment/string, price_per_day:decimal,
 category_id:references, availability_status:string, listed_at:datetime

●	Validations:

○	Presence: owner_id, title, price_per_day

○	Numericality: price_per_day > 0

○	Inclusion: availability_status ∈ {available, pending, unavailable}

○	Image: content-type and size checks

●	Associations:
 belongs_to :owner, class_name: 'User'
 belongs_to :category

Views
●	items/new

○	Form fields: Title, Price per day, Category (select), Description, Availability (select/radio), Image upload

○	Shows validation errors inline; primary action button “Create Item”

●	items/show

○	Displays Title, image, price, category, availability, description, listed_at

Controller: ItemsController
●	new

○	Renders form; restricted to signed-in Owners

●	create

○	Authorization: only Owners

○	Strong params: :title, :description, :price_per_day, :category_id, :availability_status, :item_image

○	owner_id derived from current_user (not from form)

○	Success → redirect to show with success flash

○	Failure → re-render new with error messages

