Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get 'profile' => 'devise/registrations#edit', as: 'edit_profile'
  end
  root 'home#index'
  get 'about', controller: 'about', to: :index, as: :about
  resources :trails
end
