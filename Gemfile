source 'https://rubygems.org'

ruby_version = File.read('.ruby-version').chomp
ruby ruby_version

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.2'
gem 'puma', '~> 3.11.0'
gem 'sass-rails', '~> 5.0.7'
gem 'uglifier', '~> 4.1.3'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'webpacker', '~> 3.2.0'
gem 'wicked', '~> 1.3.2'
gem 'react-rails', '~> 2.4.3'

group :development, :test do
  gem 'rspec-rails', '~> 3.5.0'
  gem 'rubocop', '~> 0.52.1'
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
