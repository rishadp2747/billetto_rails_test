# frozen_string_literal: true

sidekiq_redis_url = Rails.application.credentials.dig(:redis, :sidekiq_url)

Sidekiq.configure_client do |config|
  config.redis = {
    url: sidekiq_redis_url,
    size: 4,
    network_timeout: 5
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: sidekiq_redis_url,
    size: 12, # server needs more concurrency
    network_timeout: 5
  }

  # Load cron jobs if config present
  schedule_file = Rails.root.join("config/sidekiq_cron.yml")

  if File.exist?(schedule_file)
    raw = YAML.load_file(schedule_file, aliases: true)
    schedule = raw[Rails.env] || raw
    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end
