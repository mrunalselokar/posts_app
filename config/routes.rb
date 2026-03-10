Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "posts/index"
      get "posts/create"
      get "posts/update"
      get "users/index"
      get "users/create"
      get "users/update"

      resources :users do
        resources :posts, only: [:index, :create, :update]
        # /api/v1/users/:user_id/posts for index and create
        # /api/v1/users/:user_id/posts/:id for update
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
