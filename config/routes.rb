Rails.application.routes.draw do
  root 'maps#index'

  resources :maps, only: [:index, :create]
end
