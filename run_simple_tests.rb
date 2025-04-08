#!/usr/bin/env ruby

# This script runs the simple tests without loading Rails

require 'rspec'

# Configure RSpec
RSpec.configure do |config|
  # Basic RSpec configuration
  config.color = true
  config.formatter = :documentation
  
  # Don't run tests that require Rails
  config.filter_run_excluding :requires_rails => true
  
  # Run tests that don't require Rails
  config.filter_run_including :simple => true
end

# Run the tests
RSpec::Core::Runner.run(['spec/no_rails'])