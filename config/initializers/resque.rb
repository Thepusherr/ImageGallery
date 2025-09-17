# frozen_string_literal: true

require 'resque'

# Configure Redis connection for Resque
redis_config = {
  host: ENV.fetch('REDIS_HOST', 'localhost'),
  port: ENV.fetch('REDIS_PORT', 6379),
  db: ENV.fetch('REDIS_DB', 0)
}

Resque.redis = Redis.new(redis_config)

# Set up Resque logger
Resque.logger = Rails.logger

# Configure Resque to use ActiveJob adapter (optional)
# This allows using ActiveJob syntax with Resque backend
Rails.application.config.active_job.queue_adapter = :resque
