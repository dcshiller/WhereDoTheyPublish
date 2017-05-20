Rails.application.routes.draw do
  root to: "pages#welcome"
  get 'about', to: "pages#about"
  resources :authors, only: [:index, :show, :edit, :update, :update] do
    scope module: :authors do
      resource :affiliations, only: [:edit, :update]
    end
   end
  resources :institution, only: [:index]
  resources :journals, only: [:index, :show, :edit, :update] do
    scope module: :journals do
      resources :publications, only: [:index] do
        collection do
          get 'year/:year', to: 'publications#year', as: "year"
        end
      end
    end
    get 'affinities', to: 'journals#affinities', as: "affinities"
  end
  resources :publications
  get :data, to: "data#index"
  resources :projects, only: [:index] do
    collection do
      get :journal_counts, to: "projects#journal_counts"
      get :publication_counts, to: "projects#publication_counts"
      get :gender_balance_chart, to: "projects#gender_balance_chart"
      get :where_do_they_publish, to: "projects#where_do_they_publish_show"
      post :where_do_they_publish, to: "projects#where_do_they_publish_query"
      get :journal_affinity, to: "projects#journal_affinity_show"
      post :journal_affinity, to: "projects#journal_affinity_query"
      get :title_ngram_chart, to: "projects#title_ngram_chart"
      post :title_ngram_chart, to: "projects#title_ngram_chart"
    end
  end

  mount Resque::Server.new, at: "/resque"
end
