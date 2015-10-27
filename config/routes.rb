Rails.application.routes.draw do
  root 'home#index'
  get 'about', controller: 'about', to: :index, as: :about
  resources :trails
end
