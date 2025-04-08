# Patch for Rails engine.rb to fix the frozen array issue
module RailsEnginePatch
  def self.apply
    return unless defined?(Rails::Engine)
    
    Rails::Engine.class_eval do
      # Override the paths_for_with_subpaths method to handle frozen arrays
      alias_method :original_paths_for_with_subpaths, :paths_for_with_subpaths if method_defined?(:paths_for_with_subpaths)
      
      def paths_for_with_subpaths(paths, subpaths)
        paths = paths.dup if paths.frozen?
        subpaths = subpaths.dup if subpaths.frozen?
        
        original_paths_for_with_subpaths(paths, subpaths)
      end
    end
  end
end

# Apply the patch
RailsEnginePatch.apply