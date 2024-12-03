# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'posts#index'

  devise_for :users, controllers: {
    sessions: 'sessions'
  }, path: '', path_names: { sign_in: 'sign_in', sign_out: 'sign_out' }

  resources :posts, only: %i[show new create edit update destroy]
end
