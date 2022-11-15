# frozen_string_literal: true

Rails.application.routes.draw do
  resources :healthcheck, only: :index

  namespace :api do
    namespace :v1 do
      devise_for :users
    end
  end
end
