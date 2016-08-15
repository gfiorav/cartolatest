Rails.application.routes.draw do
  root 'maps#index'

  resources :maps, only: [:index, :create]

  mount ActionCable.server => '/cable'
end
