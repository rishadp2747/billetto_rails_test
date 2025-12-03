# Vote

A Rails application for voting on events.

## Prerequisites

- Ruby 3.3.5
- PostgreSQL
- Redis
- Node.js and Yarn

## Setup

1. **Install dependencies:**
   ```bash
   ./bin/setup
   ```

2. **Configure credentials:**
   ```bash
   EDITOR="code --wait" bin/rails credentials:edit
   ```
   
   Add the following keys:
   ```yaml
   clerk:
     secret_key: your_clerk_secret_key
     publishable_key: your_clerk_publishable_key
   
   billetto:
     api_key: your_billetto_api_key
     secret_key: your_billetto_secret_key
   
   redis:
     cache_url: redis://localhost:6379/1
     app_url: redis://localhost:6379/2
     sidekiq_url: redis://localhost:6379/3
   ```

3. **Event seeding:**

   When you run `./bin/setup`, it will automatically schedule `EventsSeederJob` via Sidekiq **only if there are no events in the database**. This job pulls public events from Billetto and seeds them into the local database.

4. **Start services:**
   ```bash
   # Start PostgreSQL and Redis (if not already running)
   # Then start the application:
   foreman start -f Procfile.dev
   ```

   This starts:
   - Rails server on http://localhost:3000
   - Vite dev server
   - Sidekiq worker

## Running Tests

```bash
bundle exec rails test -v
```

## Development

The application uses:
- **Rails 8.1** with PostgreSQL
- **React** components via react-rails
- **Vite** for frontend asset bundling
- **Sidekiq** for background jobs
- **Clerk** for authentication
- **Rails Event Store** for event sourcing

## Design Choices and Assumptions

### Event Synchronization

- Events sync from Billetto every 2 hours via a cron job. If the database is empty during setup, events are automatically seeded. All syncing happens in the background so it doesn't slow down the app.
- The system efficiently fetches events from the last synced event onwards in each iteration, avoiding redundant data retrieval and minimizing API calls.
- On initial fetch, if more data is available to fetch, the system schedules a separate job to fetch the next set of data. This approach makes things faster and reduces load on Sidekiq.
- In case of rate limit errors, the system relies on Sidekiq's exponential backoff retry mechanism to handle retries automatically.

### Event Sourcing

- The application uses **Rails Event Store** for event sourcing.
- Every vote change is recorded as an event (`EventUpvoted`, `EventDownvoted`).
- This provides a complete history of all votes and allows replaying events if needed.
- Each event has its own stream, so the vote history can be easily viewed for any specific event.
- Vote counts update automatically when events are published—this keeps the voting logic separate from counting, making the code easier to maintain.

### Vote System

- An event vote model was added to ensure one user has only one vote record for an event.
- Users can only vote once per event, but they can change their mind (switch from like to dislike or vice versa).
- Vote counts are stored separately for fast reads, and they stay in sync through event subscribers.

### Authentication & API

- The application uses Clerk for authentication—it handles all the auth complexity.
- The API uses bearer token authentication technique for securing endpoints.
- The API is versioned (`api/v1`) so changes can be made without breaking existing clients.

### Data Models

- Separate organization and organiser models were added with proper associations since they are separate entities in Billetto and their IDs are present in the API. This will be useful if the application is expanded in the future.

### Third-Party Integrations

The application uses **ACL (Anti-Corruption Layer) architecture** for implementing third-party integrations. External services (Billetto, Clerk) are wrapped in integration layers to protect the codebase from their changes. This means:
- External errors get mapped to application-specific error types
- External data gets transformed into domain models
- Implementations can be swapped or fake clients can be added for testing without changing the rest of the app

The Billetto SDK uses a facade pattern to hide HTTP complexity behind a simple interface, and adapts the Faraday library to work with Billetto's API. Only the public_events list API was added to the Billetto SDK.

## Things Not Considered

- Translation for both backend and frontend
- CSS
