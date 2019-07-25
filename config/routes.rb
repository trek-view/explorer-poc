Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create]
    end
  end

  resources :users, only:[] do
    get 'token_info', to: 'users#token_info'
    post 'generate_new_token', to: 'users#generate_new_token'
    get 'tours'

    resources :tours, only: %i[show]
  end

  resources :tours, only: %i[index]

  get '/search_tours', to: 'tours#search_tours'

  root to: 'tours#index'

end
