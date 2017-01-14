Rails.application.routes.draw do
  root to: "pages#welcome"
  resource :query, only: [:show, :create]
  resource :status, only: [:show]
  resources :authors, only: [:index, :show]
  resources :journals, only: [:index, :show]
  resources :publications, only: [:index]
  get :data, to: "data#index"
  get :projects, to: "pages#projects"
end
