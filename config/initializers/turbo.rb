# Ensure Turbo Stream MIME type is registered
Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream unless Mime::Type.lookup_by_extension(:turbo_stream)

# Simple Turbo configuration
Rails.application.config.after_initialize do
  puts "Turbo configuration loaded"
end