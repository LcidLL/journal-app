# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root route - redirect to sign in if not authenticated, dashboard if authenticated
  root to: "pages#index"
  
  # Dashboard route
  get "/dashboard", to: "pages#index"

  # Categories and nested tasks
  resources :categories do
    resources :tasks, except: [:index]
  end

  # Standalone tasks route for viewing all tasks
  get "/tasks", to: "tasks#index"
  
  # Convenience routes
  get "/my-categories", to: "categories#index"
end