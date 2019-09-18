Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :tours, only: %i[index show create update destroy] do
        resources :photos, param: :tourer_photo_id, only: %i[index show create update destroy]
      end

      get 'user_tours', to: 'tours#user_tours'
      get '*unmatched_route', to:   'base#user_not_authorized', code: 401
    end
  end

  resources :users, only: %i[] do
    post 'generate_new_token', to: 'users#generate_new_token'
    get 'tours'

    resources :tours, only: %i[show]

    resources :tour_books do
      post 'add_item', to: 'tour_books#add_item'
      delete 'remove_item', to: 'tour_books#remove_item'
    end
  end

  resources :tours, only: %i[index]

  get '/search_tours', to: 'tours#search_tours'
  get '/sitemap.xml', to: 'application#sitemap'
  get '/tour_books', to: 'tour_books#all_tour_books'

  root to: 'tours#index'

end
