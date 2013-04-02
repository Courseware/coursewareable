require 'sorcery'

module ::Coursewareable
  # Engine of Coursewareable
  class Engine < ::Rails::Engine
    isolate_namespace Coursewareable

    # Configure generators
    config.generators do |g|
      g.orm                 :active_record
      g.test_framework      :rspec, :fixture => true
      g.fixture_replacement :fabrication
    end
  end
end
