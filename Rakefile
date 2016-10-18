#!/usr/bin/env rake

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { fail_tags: ['any'] }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Run Kitchen integration tests'
task :integration do
  concurrent_tests = ENV.fetch('TEST_KITCHEN_CONCURRENY', 1)
  sh "kitchen test --concurrency #{concurrent_tests}"
end

task test_all: %w(style spec integration)
task test: %w(style spec)
