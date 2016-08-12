Rails.application.routes.draw do
  resources :cards, only: :index

  root 'cards#index'
end
