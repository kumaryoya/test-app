Rails.application.routes.draw do
  resources :aaaaas
  root to: 'posts#index'

  devise_for :users, controllers: {
    sessions: 'sessions'
  }, path: '', path_names: {sign_in: 'sign_in', sign_out: 'sign_out'}

  resources :posts, only: %i[show new create edit update destroy]
end
