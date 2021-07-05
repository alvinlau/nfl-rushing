# frozen_string_literal: true

require 'rake'

require File.expand_path('config/application', __dir__)

task :environment do
  ENV['RACK_ENV'] ||= 'development'
end

require 'mongo'
require 'json'
task :seed do
  data = JSON.parse (File.read './rushing.json'), symbolize_names: true
  puts "#{data.size} player entries found"

  client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'local')  
  client[:players].drop
  result = client[:players].insert_many data
  puts "#{result.inserted_count} player entries added"
end

# rspec tasks
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# rubocop tasks
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[spec rubocop]

# grape-swagger tasks
require 'grape-swagger/rake/oapi_tasks'
GrapeSwagger::Rake::OapiTasks.new(::Api::Base)

# starter tasks
require 'starter/rake/grape_tasks'
Starter::Rake::GrapeTasks.new(::Api::Base)
