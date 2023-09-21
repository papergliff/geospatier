Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/geospatial", to: "geospatial#create"

  get "/tickets", to: "tickets#index"
  get "/tickets/:id", to: "tickets#show"
end
