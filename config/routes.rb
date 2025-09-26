Rails.application.routes.draw do
  mount ActiveStorage::Engine => '/rails/active_storage'
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  ActiveAdmin.routes(self)

  # Resque Web UI (only for admins)
  # Resque Web UI (commented out for now - requires authentication setup)
  # require 'resque/server'
  # mount Resque::Server.new, at: '/admin/resque'

  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/starter_page'
  get 'home/gallery'
  get 'home/gallery/:category_id', to: 'categories#show', as: 'home_gallery_category'
  get 'home/gallery_single'
  get 'home/services'

  get 'profile', to: 'profile#index'
  get 'my_posts', to: 'users/posts#my_posts'
  get "up" => "rails/health#show", as: :rails_health_check
  post "toggle_like", to: "likes#toggle_like", as: :toggle_like
  post "test_turbo", to: "home#test_turbo"

  # Locale switching
  get 'switch_locale/:locale', to: 'locales#switch', as: :switch_locale
  patch 'switch_locale/:locale', to: 'locales#switch'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end



  resources :users do
    resources :posts, only: [:index], controller: 'users/posts'
  end
  resources :likes
  resources :comments
  resources :posts do
    resources :likes, only: [:create]
    resources :comments, only: [:create]
    collection do
      get :uncategorized
    end
  end
  resources :categories, param: :id do
    member do
      get 'show_image/:image_index', to: 'categories#show_image', as: 'show_image'
      delete 'destroy', to: 'categories#destroy', as: 'destroy_category'
    end
    
    resource :subscription, only: [:create, :destroy]
  end

  root to: "home#index"
end
