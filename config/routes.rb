Rails.application.routes.draw do
  get "home/index"
  # Root route
  root "home#index"

  # Health check routes
  get "health" => "health#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Owners routes
  resources :owners do
    # Patients nested under owners
    resources :patients do
      # Appointments nested under patients
      resources :appointments do
        member do
          patch :start
          patch :complete
          patch :cancel
        end

        # Invoices nested under appointments
        resources :invoices do
          member do
            post :add_product_by_barcode
            delete :remove_product, to: "invoices#remove_product"
            patch :mark_as_paid
            patch :mark_as_cancelled
          end
        end
      end
    end
  end

  # Products routes
  resources :products do
    member do
      get :barcode, defaults: { format: "html" }
      get :barcode_test
    end
  end

  # Inventory transactions routes
  resources :inventory_transactions, only: [ :index, :show ]
end
