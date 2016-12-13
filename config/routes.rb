Rails.application.routes.draw do
  root to: "queries#new"
  resource :query, only: [:new, :create]
end
