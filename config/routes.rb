Rails.application.routes.draw do
  devise_for :users

  resources :tweets do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :movies do
    resource :movie_likes, only: [:create, :destroy]
    resources :movie_comments, only: [:create, :destroy]
  end

  resources :users, only: [:show]

  get 'about' => 'homes#about'
  root "homes#top"
end