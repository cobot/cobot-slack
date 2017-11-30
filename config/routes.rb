Rails.application.routes.draw do
  root 'welcome#show'

  get 'sign_in', to: 'sessions#new', as: :sign_in
  get '/auth/:provider/callback', to: 'sessions#create', as: :authenticate
  get '/auth/failure', to: 'sessions#failure'

  resources :spaces, only: [:index, :show] do
    resources :teams, only: [:new, :create, :destroy] do
      resource :membership_confirmation, only: :create
      resource :membership_cancelation, only: :create
    end
  end

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: '/sidekiq'
end
