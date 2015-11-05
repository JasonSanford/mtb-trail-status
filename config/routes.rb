Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'  }
  root 'home#index'
  get 'about', controller: 'about', to: :index, as: :about
  resources :trails
end
