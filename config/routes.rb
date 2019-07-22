Rails.application.routes.draw do

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create]
    end
  end

  resources :users, only:[] do
    resources :tours, only: %i[index show]
  end

  root to: 'tours#index'

end
