Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "dashboard#index"

  get "expenses/splits_fields", to: "expenses#expense_splits_fields", as: :expense_splits_fields

  resources :dashboard, only: :index

  resources :money_accounts, except: :edit do
    resources :incomings
  end

  resources :item_prices, only: %i[index destroy] do
    get :barcode_reader, on: :collection
    resources :store_items, only: %i[edit update]
  end
  resources :store_items, except: %i[index edit destroy] do
    get :store_fields, on: :collection
  end
  resources :expenses, except: :index
  resources :incomings, except: %i[new create]
  resources :budgets, except: :edit
  resources :transaction_groups do
    member do
      patch :add_expense
    end
  end
end
