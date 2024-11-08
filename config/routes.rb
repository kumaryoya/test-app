Rails.application.routes.draw do
  root to: 'posts#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, path: '', path_names: {sign_in: 'sign_in', sign_out: 'sign_out'}

  resources :posts, only: %i[show new create edit update destroy]
end
