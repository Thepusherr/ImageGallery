Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  ActiveAdmin.routes(self)

  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/starter-page'
  get 'home/gallery'
  get 'home/gallery-single'
  get 'home/services'
  get 'profile', to: 'profile#index'
  get "up" => "rails/health#show", as: :rails_health_check
  post "toggle_like", to: "likes#toggle_like", as: :toggle_like
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end



  resources :users, only: [:show, :index]
  resources :likes
  resources :comments, only: [:create, :destroy]
  resources :posts
  resources :categories, param: :id do
    member do
      get ':image_index', to: 'categories#show_image', as: 'image'
      delete 'destroy', to: 'categories#destroy', as: 'destroy_category'
    end
  end

  root to: "home#index"
end
