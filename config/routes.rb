Rails.application.routes.draw do
  root 'club#home'
  get '/privateclub', to: 'club#private'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
end
