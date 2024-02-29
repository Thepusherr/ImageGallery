Rails.application.routes.draw do
  get 'categiries/show'
  get 'home/index'
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  ActiveAdmin.routes(self)

  resources :users, only: [:show, :index]
  resources :likes
  resources :comments, only: [:create, :destroy]
  resources :posts

  root to: "home#index"
end
