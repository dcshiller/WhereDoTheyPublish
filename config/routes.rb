Rails.application.routes.draw do
  root to: "pages#welcome"
  resource :query, only: [:new, :create]
  resource :status, only: [:show]
  resources :authors, only: [:index, :show]
  resources :journals, only: [:index]
  resources :publications, only: [:index]
  get :data, to: "data#index"
end
