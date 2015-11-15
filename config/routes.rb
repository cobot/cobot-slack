Rails.application.routes.draw do
  root 'sessions#new'

  get '/auth/:provider/callback', to: 'sessions#create', as: :authenticate
  get '/auth/failure', to: 'sessions#failure'

  resources :spaces, only: [:index, :show] do
    resources :teams, only: [:new, :create, :destroy] do
      resource :membership_confirmation, only: :create
    end
  end
end
