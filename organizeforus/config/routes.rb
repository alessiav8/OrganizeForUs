Rails.application.routes.draw do
  devise_for :users
  resources :groups
  #get 'home/index'
  root 'home#index'
  get 'home/about'
  resources :groups do
    resources :members 
  end 
  get'groups/inside'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
