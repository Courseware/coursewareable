#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec => :dummy_app) do |t|
  t.pattern =  File.expand_path('../spec/**/*_spec.rb', __FILE__)
end
task :default => :spec

desc 'Generates a dummy app for testing'
task :dummy_app => [:setup, :migrate]

task :setup do
  dummy = File.expand_path('../spec/dummy', __FILE__)
  next if File.exists?(dummy) and ENV['TDDIUM']

  require 'rails'
  require 'coursewareable'
  require 'coursewareable/generators/dummy_generator'

  sh "rm -rf #{dummy}"
  Coursewareable::DummyGenerator.start(
    %W(. --quiet --force --skip-bundle --old-style-hash --dummy-path=#{dummy})
  )
end

task :migrate do
  schema = File.expand_path('../spec/dummy/db/schema.rb', __FILE__)
  rakefile = File.expand_path('../spec/dummy/Rakefile', __FILE__)

  next if File.exists?(schema) and ENV['TDDIUM']

  sh("rake -f #{rakefile} coursewareable:install:migrations")
  sh("rake -f #{rakefile} db:create db:migrate db:test:prepare")
end

namespace :tddium do
  desc 'Hook to setup database on tddium'
  task :db_hook do
    tddium_config = File.expand_path('../config/database.yml', __FILE__)
    config = File.expand_path('../spec/dummy/config/database.yml', __FILE__)

    Rake::Task[:setup].invoke
    sh "cp #{tddium_config} #{config}"
    Rake::Task[:migrate].invoke
  end
end
