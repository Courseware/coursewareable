#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

desc 'Generates a dummy app for testing'
task :dummy_app => [:setup, :migrate]

task :setup do
  require 'rails'
  require 'coursewareable'
  require 'coursewareable/generators/dummy_generator'

  sh 'rm -rf spec/dummy'
  Coursewareable::DummyGenerator.start(
    %w(. --quiet --force --skip-bundle --old-style-hash --dummy-path=spec/dummy)
  )
end

task :migrate do
  cmd = 'rake -f spec/dummy/Rakefile coursewareable:install:migrations'
  cmd += ' db:drop db:create db:migrate db:test:prepare'

  system cmd
end

task :default => :dummy_app
