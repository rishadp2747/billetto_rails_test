# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :public do
      namespace :v1 do
        namespace :billetto do
          resources :webhooks, only: :create
        end
      end
    end

    namespace :v1 do
      resources :events, only: :index
      resources :event_votes, only: :create
    end
  end

  if Rails.env.development?
    mount Sidekiq::Web => "/sidekiq"
  end

  root "home#index"
end
