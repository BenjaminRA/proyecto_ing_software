Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'login#index'
  get '/dashboard', to: 'dashboard#index'

  post '/login', to: 'login#authenticate'
  get '/logout', to: 'login#logout'

  resources :collaborators
  resources :admins
  resources :profiles
  resources :users
  resources :periods
  resources :profile_abilities


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
end
