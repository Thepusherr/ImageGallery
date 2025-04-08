begin
  require 'carrierwave/orm/activerecord'
rescue LoadError => e
  Rails.logger.warn "CarrierWave not available: #{e.message}"
end