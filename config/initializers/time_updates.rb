# Schedule periodic time updates
Rails.application.config.after_initialize do
  # Only run in production or when explicitly enabled
  if Rails.env.production? || ENV['ENABLE_TIME_UPDATES'] == 'true'
    # Schedule time updates every minute
    Thread.new do
      loop do
        sleep 60 # Wait 1 minute
        TimeUpdateJob.perform_later
      end
    end
  end
end
