source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~>4.2.11'
gem 'pg'
gem 'sass-rails', '~> 5.0.7'
gem 'font-awesome-sass', git: 'https://github.com/langalex/font-awesome-sass'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'rspec-rails', group: [:development, :test]
gem 'omniauth_cobot'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth-slack'
gem 'cobot_client'
gem 'sentry-raven'
gem 'lograge'
gem 'nokogiri', '~> 1.10.8'
gem 'cobot_assets', '~> 18.4.3'
gem 'rack', '~> 1.6.12'
gem 'rake', '~>12.3.3'
gem 'slack-api', '~> 1.5.0', require: 'slack'
gem 'sidekiq'

group :production do
  gem 'puma', '~> 4.3.3'
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
