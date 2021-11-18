Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books, only: %i[index update create]
      resources :users, only: %i[index update]
      resource :favorites, only: %i[create destroy]
      resources :comments, only: %i[create destroy]
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      namespace :auth do
        resources :sessions, only: %i[index]
      end
    end
  end
end
