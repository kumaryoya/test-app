Rails.application.routes.draw do
  root to: 'posts#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, path: '', path_names: {sign_in: 'signin', sign_out: 'signout'}

  resources :posts, only: %i[show new create edit update destroy]
end
