# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        collection do
          get :count_posts
        end
      end
    end
  end

  root to: 'posts#index'

  devise_for :users, controllers: {
    sessions: 'sessions'
  }, path: '', path_names: { sign_in: 'sign_in', sign_out: 'sign_out' }

  resources :posts, only: %i[show new create edit update destroy] do
    collection do
      get :export_to_spreadsheet
    end
  end
end
