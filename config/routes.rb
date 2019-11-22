Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :tours, only: %i[index show create update destroy] do
        resources :photos, only: %i[index show create update destroy]
      end

      resources :tourbooks, only: %i[show create update destroy]

      resources :users, only: %i[show] do
        get 'tourbooks', to: 'tourbooks#get_tourbooks'
        collection do
          get 'current_account'
        end
      end

      post '/viewpoints', to: 'viewpoints#set_viewpoints'
      get '/viewpoints', to: 'viewpoints#get_viewpoints'

      get '*unmatched_route', to: 'base#user_not_authorized', code: 401
    end
  end

  resources :users, only: %i[] do
    post 'generate_new_token', to: 'users#generate_new_token'
    get 'tours'
    get 'tourbooks', to: 'tourbooks#user_tourbooks'

    resources :tours, only: %i[show] do
      member do
        post 'set_photo_view_point', to: 'tours#set_photo_view_point'
        delete 'unset_photo_view_point', to: 'tours#unset_photo_view_point'
      end
    end

    resources :tourbooks, except: %i[index] do
      member do
        post 'add_item', to: 'tourbooks#add_item'
        delete 'remove_item', to: 'tourbooks#remove_item'
      end
    end
  end

  resources :tourbooks, only: %i[index]

  resources :tours, only: %i[index]

  resources :photos, only: %i[index]

  get '/search_tours', to: 'tours#search_tours'
  get '/sitemap.xml', to: 'application#sitemap'
  get '/robots.txt' => 'robots_txts#show'

  root to: 'home#index'

end
