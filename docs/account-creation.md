# Creating an account as a new user

## User Story

As a new user without an account, I want to create an account
so that I can have access to the renting and lending features

### Acceptance Criteria

- If I click a "Sign Up" button to create my account, I will be taken to the
  account creation page
- After inputting my information and submitting, my account will be created if
  my information is valid
- If my information is not valid, I will be prompted to try again on the same
  form
- If account creation is successful, I will be signed into my account, and I
  will be redirected back to the previous page I was on before I clicked
  the "Sign Up" button

## MVC Components

### Models

A POST model that accepts at least a username and password as a string,
although in the future it would also need to accept the user's
real first and last name, email address, and phone number

### Views

A form for inputting their account information

### Controllers

A handler for a GET request to /signup and a handler for a POST to /signup
