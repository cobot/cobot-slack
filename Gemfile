source 'https://rubygems.org'

ruby '~>2.7.5'

gem 'railties', '~>5.2.4.3'
gem 'activerecord'
gem 'actionpack'
gem 'bootsnap'
gem 'pg'
gem 'rspec-rails', group: [:development, :test]
gem 'omniauth_cobot'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth-slack'
gem 'cobot_client'
gem 'sentry-raven'
gem 'lograge'
gem 'nokogiri'
gem 'rack'
gem 'rake'
gem 'slack-api', '~> 1.5.0', require: 'slack'
gem 'sidekiq'
gem 'webpacker'

group :production do
  gem 'puma'
end

group :development do
  gem 'dotenv-rails'
  gem 'listen'
end

group :test do
  gem 'capybara'
  gem 'webmock'
  gem 'launchy'
end
