require 'spork'
require 'ffaker'

# Use simplecov only if drb server is not running
unless ENV['DRB']
  require 'simplecov'
  SimpleCov.start 'rails' do
    root File.expand_path('../../', __FILE__)
  end
end

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path('../dummy/config/environment.rb',  __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'shoulda-matchers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("../../spec/support/**/*.rb")].each {|f| require f}

end

Spork.each_run do
end
