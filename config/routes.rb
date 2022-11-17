# frozen_string_literal: true

Rails.application.routes.draw do
  resources :healthcheck, only: :index

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "users"
        as :user do
          # Define routes for User within this block.
        end
    end
  end
end
