Rails.application.routes.draw do
  mount ActiveStorage::Engine => '/rails/active_storage'
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  ActiveAdmin.routes(self)

  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/starter_page'
  get 'home/gallery'
  get 'home/gallery_single'
  get 'home/services'
  get 'profile', to: 'profile#index'
  get "up" => "rails/health#show", as: :rails_health_check
  post "toggle_like", to: "likes#toggle_like", as: :toggle_like
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end



  resources :users
  resources :likes
  resources :comments
  resources :posts do
    resources :likes, only: [:create]
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
