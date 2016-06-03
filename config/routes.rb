Rails.application.routes.draw do
  root 'home#index'

  get 'oops' => 'home#oops'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get 'settings' => 'devise/registrations#edit', as: 'edit_settings'
  end

  get 'verify_phone' => 'phone#verify', as: 'verify_phone'
  post 'verify_phone' => 'phone#check_pin', as: 'check_pin'

  get 'about' => 'about#index', as: 'about'

  get 'billing' => 'billing#index', as: 'billing'

  resources :trails do
    member do
      get 'admin'
      post 'create_photo'
    end
  end
  resources :instagram_photos, only: :destroy
  resources :alerts
  resource :subscriptions, as: :subscription
end
