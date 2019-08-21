Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create] do
        resources :photos, only: [:create, :update, :destroy]
      end
      patch 'tours/:local_id', to: 'tours#update'
      delete 'tours/:local_id', to: 'tours#destroy'
      get '*unmatched_route', to:   'base#user_not_authorized', code: 401
    end
  end

  resources :users, only:[] do
    get 'info', to: 'users#info'
    post 'generate_new_token', to: 'users#generate_new_token'
    get 'tours'

    resources :tours, only: %i[show]
  end

  resources :tours, only: %i[index]

  get '/search_tours', to: 'tours#search_tours'

  root to: 'tours#index'

end
