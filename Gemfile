source 'https://rubygems.org'

ruby_version = File.read('.ruby-version').chomp
ruby ruby_version

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.12.0'
gem 'wicked', '~> 1.3.2'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'brakeman'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'rubocop', '~> 0.64.0'
end

group :test do
  gem 'rspec-html-matchers'
  gem 'rails-controller-testing'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'factory_bot_rails'
  gem 'danger'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.1.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
