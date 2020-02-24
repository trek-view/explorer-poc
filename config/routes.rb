Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :tours, only: %i[index show create update destroy] do
        resources :photos, only: %i[index show create update destroy]
      end

      resources :tourbooks
      resources :guidebooks

      resources :users, only: %i[show] do
        collection do
          get 'current_account'
        end

        resources :tourbooks, only: %i[index]
      end

      post '/viewpoints', to: 'photos#set_viewpoints'
      get '/viewpoints', to: 'photos#get_viewpoints'
      get '/users', to: 'users#get_info'

      get '*unmatched_route', to: 'base#user_not_authorized', code: 401
    end
  end

  resources :users, only: %i[show] do
    post 'generate_new_token', to: 'users#generate_new_token'
    post 'submit_request_apikey', to: 'users#submit_request_apikey'

    resources :tours

    resources :tourbooks do
      member do
        post 'add_item', to: 'tourbooks#add_item'
        delete 'remove_item', to: 'tourbooks#remove_item'
      end
    end

    get 'viewpoints', to: 'photos#viewpoints'

    resources :guidebooks do
      member do
        post 'add_item', to: 'guidebooks#add_item'
        delete 'remove_item', to: 'guidebooks#remove_item'
      end
      resources :scenes do
        get 'guidebook_scenes', to: 'scenes#guidebook_scenes'
        get 'photo/:id', to: 'photos#show'
      end
    end
  end

  resources :photos, only: %i[index show] do
    collection do
      get 'viewpoints'
    end
  end

  resources :tours, only: %i[index show]
  resources :tourbooks, only: %i[index show]
  get '/viewpoints', to: 'photos#viewpoints'
  resources :guidebooks, only: %i[index show]
  resources :scenes, only: %i[index show]

  get '/search_tours', to: 'tours#search_tours'
  get '/sitemap.xml', to: 'application#sitemap'
  get '/robots.txt' => 'robots_txts#show'
  get '/about', to: 'home#about'
  get '/upload', to: 'home#upload'
  get '/select_scene_photo' => 'scenes#select_scene_photo', as: 'select_scene_photo'

  root to: 'home#index'
end
