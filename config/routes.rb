Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  ActiveAdmin.routes(self)

  get 'categiries/show'
  get 'home/index'
  get "up" => "rails/health#show", as: :rails_health_check
  post "toggle_like", to: "likes#toggle_like", as: :toggle_like
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users, only: [:show, :index]
  resources :likes
  resources :comments, only: [:create, :destroy]
  resources :posts

  root to: "home#index"
end
