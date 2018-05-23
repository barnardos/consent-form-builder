# frozen_string_literal: true

source 'https://rubygems.org'

ruby_version = File.read('.ruby-version').chomp
ruby ruby_version

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg', '~> 0.2'
gem 'puma', '~> 3.11.0'
gem 'rails', '~> 5.1.6'
gem 'webpacker', '~> 3.4'
gem 'wicked', '~> 1.3.2'

group :development, :test do
  gem 'rspec-rails', '~> 3.5.0'
  gem 'rubocop', '~> 0.52.1'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'danger'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-html-matchers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.1.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
