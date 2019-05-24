Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#index'
  # get 'users/index'

  resources :collaborators
  resources :admins
  resources :profiles
  resources :abilities
  resources :profile_abilities
end
