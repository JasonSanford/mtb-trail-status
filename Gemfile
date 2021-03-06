source 'https://rubygems.org'

if ENV['RAILS_ENV'] === 'production'
  ruby '2.2.4'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'friendly_id'
gem 'nokogiri'
gem 'twitter'
gem 'devise', '~> 3.4.0'
gem 'phony_rails'
gem 'twilio-ruby'
gem 'stripe'
gem 'rollbar', '~> 2.11.0'
gem 'haml-rails', '~> 0.9'
gem 'roadie-rails', '~> 1.0'
gem 'money'
gem 'forecast_io'
gem 'httparty'
gem 'cancancan', '~> 1.10'
gem 'meta-tags'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'foreman'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'puma'
end

group :development do
  gem 'mailcatcher'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'bundler'
end
