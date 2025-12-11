Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # ----- CUSTOM PASSWORD RESET FLOW -----
  get  "/password_reset",            to: "password_resets#username_form"
  post "/password_reset/check",      to: "password_resets#verify_username"

  get  "/password_reset/questions",  to: "password_resets#security_questions"
  post "/password_reset/verify",     to: "password_resets#verify_answers"

  get  "/password_reset/new",        to: "password_resets#new_password"
  patch "/password_reset/update",    to: "password_resets#update_password"

  # Security Questions Password-Reset Flow
  post "/security/lookup", to: "security_questions#lookup", as: :security_questions_lookup
  get  "/security/verify/:id", to: "security_questions#verify", as: :security_questions_verify
  post "/security/check_answers/:id", to: "security_questions#check_answers", as: :security_questions_check_answers
  get  "/security/reset_password/:id", to: "security_questions#reset_password", as: :security_questions_reset_password
  patch "/security/update_password/:id", to: "security_questions#update_password", as: :security_questions_update_password

  # ---------------------------------------

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  #root "items#index"     #commenting to resolve merge conflicts, will delete if sucessful don't want to mess too much up
  
  get  "/dashboard", to: "dashboards#show"

  root "home#index"

  # item_upload
  resources :items, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  
  # Booking routes
  resources :bookings do
    member do
      patch :approve
      patch :decline
    end
    resources :payments, only: [:new, :create, :show]
  end

  # Contact routes
  resources :contacts, only: [:new, :create]

  # Admin namespace
  namespace :admin do
    resources :users, only: [:index, :show, :update]
    resources :items, only: [:destroy]
    resources :contacts, only: [:index, :show]
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :disputes, only: [:create] do
        collection do
          get :mine
        end
      end

      namespace :admin do
        post "ban", to: "admin#ban"
        post "disputes/new", to: "disputes#create"
        get "disputes", to: "disputes#index"
        patch "disputes/:id/resolve", to: "disputes#resolve"
      end
    end
  end

end
