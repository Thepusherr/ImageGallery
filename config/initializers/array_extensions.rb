# frozen_string_literal: true

# Simple extension to handle frozen arrays safely
class Array
  # Safe version of unshift that handles frozen arrays
  def safe_unshift(*args)
    if frozen?
      # If array is frozen, create a new array with the elements
      new_array = dup
      new_array.unshift(*args)
      new_array
    else
      # If not frozen, just use regular unshift
      unshift(*args)
    end
  end
end

# Only apply in test environment
# Monkey patch Rails::Engine to use safe_unshift
if Rails.env.test? && defined?(Rails::Engine)
  module Rails
    class Engine
      class << self
        # Store original paths_for method
        alias original_paths_for paths_for if method_defined?(:paths_for)

        # Override paths_for to handle frozen arrays
        def paths_for(paths)
          # Make sure we're working with an unfrozen array
          paths = paths.dup if paths.frozen?
          original_paths_for(paths)
        end
      end
    end
  end
end
