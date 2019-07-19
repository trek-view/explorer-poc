Rails.application.routes.draw do

  devise_for :users do
    resources :tours, only: %i[index show]
  end

  namespace :api do
    namespace :v1 do
      resources :tours, only: %i[create]
    end
  end

end
