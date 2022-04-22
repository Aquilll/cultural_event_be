Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :events, only: :index do
    collection do
      post :create_gorki_events
      post :create_co_berlin_events
    end
  end

  resources :search, only: [:index]
end
