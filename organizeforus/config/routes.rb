Rails.application.routes.draw do
  devise_for :users

  #Definita la route di sign_out:
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
 end

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
