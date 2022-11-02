Rails.application.routes.draw do
  resources :healthcheck, only: :index
end
