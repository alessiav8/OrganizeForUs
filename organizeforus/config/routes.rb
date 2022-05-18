Rails.application.routes.draw do
  devise_for :users
  resources :gruppos
  #get 'home/index'
  root 'home#index'
  get 'home/about'
  resources :gruppos do
    resources :members 
  end 
  get'gruppos/inside'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
