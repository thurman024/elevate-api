# Elevate API

A Rails 8.0 API application with user authentication.

## Requirements

- Ruby (version specified in `.ruby-version`)
- SQLite 3

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd elevate-api
```

2. Upload the provided .env file or add the billing service JWT token yourself

3. Install dependencies and set up the database:
```bash
bin/setup
```

This script will:
- Install Ruby gems
- Set up the database
- Clear logs and temporary files
- Start the development server automatically

## Usage

The API requires authentication for most endpoints using a Bearer token in the Authorization header:
```
Authorization: Bearer <session_token>
```

### Authentication Endpoints

#### Login
```
POST /api/sessions
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "your_password"
}
```
Returns a session token to use for authenticated requests.

### User Endpoints

#### Create User
```
POST /api/user
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "your_password"
  }
}
```

#### Get User Profile
```
GET /api/user
Authorization: Bearer <session_token>
```

### Game Events

#### Track Game Completion
```
POST /api/user/game_events
Authorization: Bearer <session_token>
Content-Type: application/json

{
  "game_event": {
    "type": "COMPLETED"
  }
}
```
Increments the user's games_played counter.

## Testing

The project uses RSpec for testing.

To run the test suite:
```bash
bundle exec rspec
```


