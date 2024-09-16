Rails.application.routes.draw do


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
    
      get "/me", to: "users#me"
      post "/auth/login", to: "auth#login"

      resources :roles, only: [:index, :create, :destroy]
      resources :users, only: [:index, :create, :destroy,:update]
      resources :artists, only: [:index, :create, :destroy,:update]
      resources :musics, only: [:index, :create, :destroy,:update,:show]


    end
  end

end
