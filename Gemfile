source 'https://rubygems.org'

ruby '2.3.4'

gem 'rails', '4.2.7.1'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'rspec-rails', group: [:development, :test]
gem 'omniauth_cobot'
gem 'omniauth-slack'
gem 'cobot_client'
gem 'sentry-raven'
gem 'lograge'
gem 'cobot_assets', '~> 0.0.9'
gem 'slack-api', '~> 1.5.0', require: 'slack'
gem 'sidekiq'

group :production do
  gem 'puma'
  gem 'rails_12factor'
end

group :development do
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'webmock'
  gem 'launchy'
end
