# frozen_string_literal: true

app_redis_url = Rails.application.credentials.dig(:redis, :app_url)

# Dedicated Redis pool for app-level usage (NOT cache, NOT Sidekiq)
AppRedis = RedisClient.config(
  url: app_redis_url,
  connect_timeout: 30,
  read_timeout: 0.4,
  write_timeout: 0.4,
  reconnect_attempts: 1
).new_pool(
  size: 10,
  timeout: 5
)
