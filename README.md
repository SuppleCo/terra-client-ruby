# Terra Ruby Client

A Ruby wrapper for the [Terra API](https://docs.tryterra.co/reference) - health and fitness data from wearables.

## Installation

```sh
gem install tryterra-client
```

## Quick Start

```ruby
require 'Terra'

begin
  terra = TerraAPI::Terra.new(YOUR_DEV_ID, YOUR_API_KEY)
rescue TerraError => e
  puts e.message
end

# Get list of providers
puts terra.get_providers
```

## API Reference

### Authentication

```ruby
# Generate widget session (user selects provider)
terra.generate_widget_session(
  reference_id,              # Your internal user ID
  providers,                 # Array of provider strings, e.g. ["FITBIT", "GARMIN"]
  language,                  # e.g. "en"
  auth_success_redirect_url,
  auth_failure_redirect_url
)

# Direct authentication link (specific provider)
terra.authenticate_user(
  "FITBIT",                              # Provider (required)
  reference_id: "user@example.com",      # Optional
  language: "en",                        # Optional
  auth_success_redirect_url: "https://...",
  auth_failure_redirect_url: "https://..."
)

# Generate auth token for mobile SDK (Apple Health, Samsung Health)
terra.generate_auth_token

# Deauthenticate a user
terra.deauth_user(user_id)
```

### Providers & Integrations

```ruby
# Get list of available providers
terra.get_providers

# Get detailed provider info (includes supported data types)
terra.get_providers_detailed
terra.get_providers_detailed(sdk: true)  # Include SDK integrations
```

### Users

```ruby
# Get all connected users
terra.get_subscribers

# Get user info by Terra user ID
terra.get_user(user_id)

# Get users by your reference ID
terra.get_users_by_reference(reference_id)

# Get info for multiple users (bulk)
terra.get_users_bulk(["user_id_1", "user_id_2", "user_id_3"])

# Get athlete/profile data
terra.get_athelete(user_id, to_webhook: false)
```

### Historical Data Retrieval

All data methods accept:
- `user_id` - Terra user ID (required)
- `start_date` - Date object (required)
- `end_date` - Date object (optional)
- `to_webhook` - Boolean, send to webhook instead of response (optional, default: false)

```ruby
# Activity data (workouts, exercises)
terra.get_activity(user_id, start_date, end_date, to_webhook)

# Daily summary (steps, calories, etc.)
terra.get_daily(user_id, start_date, end_date, to_webhook)

# Body metrics (weight, body fat, etc.)
terra.get_body(user_id, start_date, end_date, to_webhook)

# Sleep data
terra.get_sleep(user_id, start_date, end_date, to_webhook)

# Nutrition logs
terra.get_nutrition(user_id, start_date, end_date, to_webhook)

# Menstruation data
terra.get_menstruation(user_id, start_date, end_date, to_webhook)

# Planned workouts
terra.get_planned_workouts(user_id, start_date, end_date, to_webhook)
```

### Writing Data

Write data to providers that support it:

```ruby
# Post activity data
terra.post_activity(user_id, data)

# Post nutrition logs
terra.post_nutrition(user_id, data)

# Post body metrics
terra.post_body(user_id, data)

# Post planned workout
terra.post_planned_workout(user_id, data)
```

### Deleting Data

```ruby
# Delete nutrition logs
terra.delete_nutrition(user_id, ["log_id_1", "log_id_2"])

# Delete body metrics
terra.delete_body(user_id, ["log_id_1", "log_id_2"])

# Delete planned workouts
terra.delete_planned_workouts(user_id, ["workout_id_1", "workout_id_2"])
```

### Lab Reports

Upload lab reports (PDF, PNG, JPEG) for AI-powered biomarker extraction:

```ruby
# Upload single file
terra.upload_lab_report("/path/to/bloodtest.pdf")

# Upload with reference ID
terra.upload_lab_report("/path/to/report.pdf", reference_id: "patient_123")

# Upload multiple files (max 10)
terra.upload_lab_report([
  "/path/to/page1.pdf",
  "/path/to/page2.jpg"
], reference_id: "patient_123")
```

### Webhooks

```ruby
# Parse incoming webhook payload
terra.parse_webhook(payload, type, user_id)
```

## Example

```ruby
require 'Terra'
require 'date'

begin
  terra = TerraAPI::Terra.new(YOUR_DEV_ID, YOUR_API_KEY)
  
  # Get providers
  providers = terra.get_providers
  puts providers
  
  # Get activity data for a user
  start_date = Date.new(2024, 1, 1)
  end_date = Date.new(2024, 1, 7)
  
  activity = terra.get_activity(
    "user-id-here",
    start_date,
    end_date
  )
  puts activity
  
rescue TerraError => e
  puts "Error: #{e.message}"
end
```

## Documentation

- [Terra API Reference](https://docs.tryterra.co/reference)
- [Data Models](https://docs.tryterra.co/data-models)
- [Lab Reports API](https://docs.tryterra.co/lab-reports/lab-report-api-documentation)

## License

Apache License 2.0
