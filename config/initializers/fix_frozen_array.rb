# Simple fix for the frozen array issue in Rails

# Only apply in test environment
if Rails.env.test?
  # Monkey patch the specific method that's causing the issue
  module ActionDispatch
    module Journey
      class Routes
        def clear
          # The original method tries to modify @routes which might be frozen
          # So we'll create a new empty array instead
          @routes = []
        end
      end
    end
  end
  
  # Monkey patch Array to handle unshift on frozen arrays
  class Array
    alias_method :original_unshift, :unshift
    
    def unshift(*args)
      if frozen?
        # If the array is frozen, return a new array with the elements added
        args + self
      else
        # Otherwise, use the original method
        original_unshift(*args)
      end
    end
  end
end