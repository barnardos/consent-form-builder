# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if %w[development test].include? Rails.env
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

task(:default).clear
task default: [:spec, :cucumber, :rubocop, 'npm:test:unit', 'npm:test:jest', 'npm:lint']
