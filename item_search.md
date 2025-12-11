Task 1
User Story:
As a renter, I want to search and filter available rental listings so that I can find items that I’m looking to rent.

Acceptance Criteria:
User can type in a word /phrase to see matching items
User can filter results by category and available date range and only listings with the category and available range will be shown. 
Search results include item name, image, price , owner name, and availability window
If no results are found, the user will be shown a “no items found” message
Clicking on a result will bring the user to that item’s view

Task 2
Models
Item model with title:string, description: string,  availability_start:datetime, availability_end: datetime, price_per_day: decimal, category_id: int / foreign key, owner_id: int/foreign key
Category model with attributes category_id: int, category_name: string
User model with attributes user_id: int, username: string, first_name: string, last_name: string, email: string, phone: string, roles: string, account_created_at: datetime, report_count: int, account_status: string

Views
items/details.html.erb
items/search.html.erb

Controllers
an Items controller with search and details actions
