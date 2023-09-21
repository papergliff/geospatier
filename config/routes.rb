Rails.application.routes.draw do
  post "/geospatial", to: "geospatial#create"
  root "tickets#index"

  get "/tickets", to: "tickets#index"
  get "/tickets/:id", to: "tickets#show"
end
