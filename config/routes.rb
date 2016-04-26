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
end
