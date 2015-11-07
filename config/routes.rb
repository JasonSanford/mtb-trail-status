Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get 'profile' => 'devise/registrations#edit', as: 'edit_profile'
  end

  get 'verify_phone' => 'phone#verify', as: 'verify_phone'

  get 'about' => 'about#index', as: 'about'

  resources :trails
end
