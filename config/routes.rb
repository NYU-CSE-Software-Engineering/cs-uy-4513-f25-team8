Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  #root "items#index"     #commenting to resolve merge conflicts, will delete if sucessful don't want to mess too much up

  get  "/login",     to: "sessions#new"
  post "/login",     to: "sessions#create"
  get  "/dashboard", to: "dashboards#show"

  #Account creation route
  get "/signup", to: "users#new", as: :signup
  post "/users", to: "users#create"
  root "home#index"

  # Booking routes
  post "/bookings", to: "bookings#create"
  patch "/bookings/:id/approve", to: "bookings#approve"


  # item_upload
  resources :items, only: [:new, :create, :show, :index]
  
  
  resources :bookings do
    resources :payments, only: [:new, :create, :show]
  end


end
