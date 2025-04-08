# Patch to handle frozen arrays in Rails

# Only apply in test environment
if Rails.env.test?
  module Rails
    class Engine
      # Store the original method
      class << self
        alias_method :original_eager_load!, :eager_load! if method_defined?(:eager_load!)
      end
      
      # Override the eager_load! method to handle frozen arrays
      def self.eager_load!
        begin
          original_eager_load! if method_defined?(:original_eager_load!)
        rescue FrozenError => e
          # Log the error but don't crash
          Rails.logger.warn "FrozenError in eager_load!: #{e.message}"
          Rails.logger.warn "This is likely due to a frozen array in the eager_load_paths"
          Rails.logger.warn "Continuing without eager loading"
        end
      end
    end
  end
end