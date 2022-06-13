Rails.application.routes.draw do
  host = if ENV['STAGING'] == 'true'
           Rails.application.credentials[:staging][:host]
         else
           Rails.application.credentials[Rails.env.to_sym][:host]
         end
  default_url_options(host: host)

  namespace :api do
    namespace :v1 do
      namespace :users do
        resources :api_credentials, only: [:update, :create]
        resources :currencies, only: :index
        resources :deposits, only: [:create, :index]
        resources :financial_transactions, only: :index
        resources :financial_reasons, only: :index
        resources :payment_gateway_notifications, only: :create
        resources :orders, only: %i[create show]
        resources :registrations, only: :create
        resources :register_confirmations, only: [:create]
        resources :sessions, only: [:create, :destroy]
        resources :passwords, only: %i[new create update]
        resources :payment_methods, only: [:index]
        resources :products, only: [:index]
        resources :system_parametrizations, only: :index
        resources :unilevel_nodes, only: :index
        resource :address, only: [:create, :update]
        resource :users, only: [:update]
        resources :user_profiles, only: :create
        resources :withdraws, only: [:create, :index]
        resources :withdraw_confirmations, only: :create
      end
    end
  end
end
