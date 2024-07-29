# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'static_pages#top'
  resources :diaries, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end
  resources :likes, only: %i[create] do
    collection do
      post 'everything'
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'memories', to: 'memories#index'
  get 'missions/:type', to: 'missions#show', as: 'missions'
  resource :profile
  # テストユーザー用のログインルートを追加
  devise_scope :user do
    get 'test_sign_in', to: 'users/sessions#test_sign_in', as: :test_sign_in
    post 'test_sign_in', to: 'users/sessions#test_sign_in_user'
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
