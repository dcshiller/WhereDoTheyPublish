Rails.application.routes.draw do
  root to: "pages#welcome"
  resources :authors, only: [:index, :show, :edit, :update, :update]
  resources :journals, only: [:index, :show, :edit, :update] do
    get 'year/:year', to: 'journals#year', as: "year"
    get 'affinities', to: 'journals#affinities', as: "affinities"
  end
  resources :publications, only: [:index, :edit, :update]
  get :data, to: "data#index"
  resources :projects, only: [:index] do
    collection do
      get :where_do_they_publish, to: "projects#where_do_they_publish_show"
      post :where_do_they_publish, to: "projects#where_do_they_publish_query"
      get :journal_affinity, to: "projects#journal_affinity_show"
      post :journal_affinity, to: "projects#journal_affinity_query"
    end
  end
end
