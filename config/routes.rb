Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "dashboard#index"

  get "expenses/splits_fields", to: "expenses#expense_splits_fields", as: :expense_splits_fields
  resources :money_accounts, only: :index
  resources :expenses, except: :index
end
