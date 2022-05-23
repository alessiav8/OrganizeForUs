Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  #Definita la route di sign_out:
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy' 
    post '/user/auth/facebook/callback/after_social_connection' => 'users/after_auth#create'
 end

  resources :groups
  #get 'home/index'
  root 'home#index'
  get 'home/about'
  
  resources :groups do
    resources :members , only: [:new,:edit,:create]
  end 

  get '/groups/:group_id/members', to: 'members#show', as: 'show_member'
  get '/groups/:group_id/members/:id', to: 'members#destroy', as: 'destroy_group_member'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
