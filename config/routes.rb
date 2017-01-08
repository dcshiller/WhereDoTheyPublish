Rails.application.routes.draw do
  root to: "queries#new"
  resource :query, only: [:new, :create]
  resource :status, only: [:show]
  resources :authors, only: [:index]
  resources :journals, only: [:index]
  resources :publications, only: [:index]
end
