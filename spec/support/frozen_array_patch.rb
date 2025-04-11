# Patch to handle frozen arrays in Rails middleware
module FrozenArrayPatch
  def self.apply
    # Patch the middleware stack to handle frozen arrays
    if defined?(ActionDispatch::MiddlewareStack)
      ActionDispatch::MiddlewareStack.class_eval do
        def insert_before(...)
          # Make a safe copy if the array is frozen
          @middlewares = @middlewares.dup if @middlewares.frozen?
          super
        end
        
        def insert_after(...)
          # Make a safe copy if the array is frozen
          @middlewares = @middlewares.dup if @middlewares.frozen?
          super
        end
        
        def swap(...)
          # Make a safe copy if the array is frozen
          @middlewares = @middlewares.dup if @middlewares.frozen?
          super
        end
        
        def use(...)
          # Make a safe copy if the array is frozen
          @middlewares = @middlewares.dup if @middlewares.frozen?
          super
        end
      end
    end
  end
end

# Apply the patch
FrozenArrayPatch.apply