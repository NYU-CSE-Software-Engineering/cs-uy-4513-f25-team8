# Seller Renter Communication (Feature Design) - Item Rental Saas

**Module:** Communication 

**Author:** Isabelle Larson

**Date:** 10/24/2025

---

## Task 1 - User Story 

As a **Renter**, I want to **communicate securely with an **Owner** via messaging** so that I can **organize renting their item** 
by asking questions, making plans for pickup, and keeping in contact with the **Owner**. 


## **Acceptance Criteria (Gherkin-ready)**

## **1 - Start a message in relation to an item**
**Given** I am a signed-in renter on a public, available item
**When** I open the messaging page for that item
**Then** I can begin a chat with the owner 

## **2 - Seller can respond to messages**
**Given** I am a signed-in owner, with items available for booking
**When** I get notified of a message related to an item 
**Then** I can access a chat with a renter
**And** I can respond to the renter 

## **3 - Chat history is saved and can be referred back to**
**Given** I am a signed-in owner OR renter, with a chat already in progress
**When** I return to the chat after some time passing
**Then** All previous messages are still displayed in the appropriate order



## Task 2 - MVC Components 

### ** Models**

**Message**

- **Attributes:** 
'message_id', 'booking_id' (FK), 'sender_id', 'body', 'sent_at'

- **Associations:**
'belongs_to :booking'
'belongs_to :sender, class_name: User'
'has_one :receiver, through :booking'

---

**Booking (existing)**

---

**User (existing)**

---

### **Views**

**'messages/index'**
- displays the ongoing message threads for logged-in user

**'messages/show'**
- displays the conversation between renter and owner for a specific item or booking

**'messages/_form'**
- contains the input field and send button for submitting a new message

---

### **Controllers**

**MessagesController**

- **'index'** - Retrieves all message threads for the current user
- **'show'** - Displays all messages for a specific booking (ordered by timestamp)
- **'create'** - Saves a new message to the database and triggers a notification to the recipient
- **'update'** - Marks messages as read when viewed by the receiver

