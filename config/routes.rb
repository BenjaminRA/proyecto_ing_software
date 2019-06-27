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

  get "/periods/:period/:collaborator", to: "periods#report"

  get "/autoevaluations/:id/", to: "autoevaluations#new"
  post "/autoevaluations", to: "autoevaluations#create"
  get "/autoevaluations", to: "autoevaluations#index"
  post "/autoevaluations/:id", to: "autoevaluations#update"
  get "/autoevaluations/:id/edit", to: "autoevaluations#edit"

  get "/evaluations/:id/new", to: "evaluations#new"
  get "/evaluations/:id", to: "evaluations#show"
  post "/evaluations", to: "evaluations#create"
  get "/evaluations", to: "evaluations#index"
  post "/evaluations/:id", to: "evaluations#update"
  get "/evaluations/:id/edit", to: "evaluations#edit"


  post '/abilities', to: 'abilities#create'
  get '/abilities', to: 'abilities#index'
  # get '/abilities/:id', to: 'abilities#update'
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
