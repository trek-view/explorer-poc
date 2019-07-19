Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create]
    end
  end

  resources :tours, only: %i[index show]

  root to: 'tours#index'

end
