Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#index'
  # get 'users/index'

  resources :collaborators
  resources :admins
  resources :profiles


  post '/abilities', to: 'abilities#create'
  get '/abilities', to: 'abilities#index'
  delete '/abilities/:id', to: 'abilities#destroy'
  put '/abilities/:id', to: 'abilities#update'

  get '/abilities/tecnicas', to: 'abilities_tecnicas#index'

  get '/abilities/blandas', to: 'abilities_blandas#index'

  get '/abilities/blandas/categories', to: 'categories#index'
  delete '/abilities/blandas/categories/:id', to: 'categories#destroy'
  put '/abilities/blandas/categories/:id', to: 'categories#update'
  
  get '/abilities/blandas/areas', to: 'areas#index'
  delete '/abilities/blandas/areas/:id', to: 'areas#destroy'
  put '/abilities/blandas/areas/:id', to: 'areas#update'
  resources :profile_abilities
end
