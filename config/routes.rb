Rails.application.routes.draw do
  root to: "pages#welcome"
  resource :query, only: [:show, :create]
  resources :authors, only: [:index, :show, :edit, :update, :update]
  resources :journals, only: [:index, :show] do
    get 'year/:year', to: 'journals#year', as: "year"
  end
  resources :publications, only: [:index]
  get :data, to: "data#index"
  get :projects, to: "pages#projects"
end
