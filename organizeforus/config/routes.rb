Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

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

 resources :partecipations , only:[:new,:create,:destroy]

  resources :groups do
    resources :roles, only: [:create]
  end 

  put 'groups/:id/partecipations/edit_driver', to: 'partecipations#edit_driver', as: 'edit_driver'


  get '/groups/:group_id/partecipations', to: 'partecipations#new', as: 'new_partecipations'
  get '/groups/:group_id/partecipations/show', to: 'partecipations#show', as: 'show_p'
  
  get 'partecipations/:id/destroy', to: 'partecipations#destroy', as: 'destroy_partecipation'
  get 'partecipations/new_role', to: 'partecipations#new_role', as: 'new_role'
  #get '/auth/:provider/callback' => 'sessions#omniauth'


    
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
