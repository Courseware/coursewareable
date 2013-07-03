#!/usr/bin/env rake
require 'bundler/setup'
require 'rails/dummy/tasks'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

ENV['DUMMY_PATH'] = File.expand_path('../spec/dummy', __FILE__)
ENV['ENGINE'] = 'coursewareable'

RSpec::Core::RakeTask.new(:spec => 'dummy:app') do |t|
  t.pattern =  File.expand_path('../spec/**/*_spec.rb', __FILE__)
end
task :default => :spec

namespace :tddium do
  desc 'Hook to setup environment on tddium'
  task :pre_hook do
    tddium_config = File.expand_path('../config/database.yml', __FILE__)
    config = File.expand_path('../spec/dummy/config/database.yml', __FILE__)

    Rake::Task['dummy:app'].invoke
    sh "cp #{tddium_config} #{config}"
  end

  # desc 'Hook to setup database on tddium'
  # task :db_hook do
  #   Rake::Task['db:migrate'].invoke
  # end
end

desc 'Run cane to check quality metrics'
begin
  require 'cane/rake_task'
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 25
  end
rescue LoadError
  task :quality
  puts 'Cane is not installed, :quality task unavailable'
end
