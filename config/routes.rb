Rails.application.routes.draw do

  devise_for :users

  resources :tours, only: %i[index show]

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create]
    end
  end

end
