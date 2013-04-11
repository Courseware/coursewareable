$:.push File.expand_path('../lib', __FILE__)

require "coursewareable/version"

Gem::Specification.new do |s|
  s.name        = 'coursewareable'
  s.version     = Coursewareable::VERSION
  s.authors     = ['Stas Suscov']
  s.email       = ['stas@coursewa.re']
  s.homepage    = 'http://coursewa.re'
  s.summary     = 'Courseware Core Engine'
  s.description = 'Courseware back-end business logic and relevant tests.'
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'cancan'
  s.add_dependency 'sorcery', '~> 0.8'
  s.add_dependency 'public_activity'
  s.add_dependency 'friendly_id'
  s.add_dependency 'paperclip'
  s.add_dependency 'sanitize'

  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'cane'
end
