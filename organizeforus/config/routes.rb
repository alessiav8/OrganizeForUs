Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }
  #Definita la route di sign_out:
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy' 
    post '/user/after_social_connection' => 'users/after_auth#create'
    get '/user/:id/:provider/unlink_account' => "users/after_auth#unlink_account", as: "unlink_account"
  end

  get '/profile' => "users#profile"
 
  resources :events
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
  resources :groups do
    resources :posts
  end 

  resources :posts do
    resources :comments
  end 

  resources :groups do
    resources :events
  end 

  put 'groups/:id/partecipations/edit_driver', to: 'partecipations#edit_driver', as: 'edit_driver'
  get '/groups/:group_id/partecipations', to: 'partecipations#new', as: 'new_partecipations'
  get '/groups/:id/set_created', to: 'groups#set_created', as: 'set_created'

  get '/groups/:group_id/partecipations/:role/delete_role', to: 'partecipations#delete_role', as: 'delete_role'

  get '/groups/:group_id/partecipations/show', to: 'partecipations#show', as: 'show_p'
  put '/groups/:group_id/partecipations/:member_id/update_role', to: 'partecipations#update_role', as: 'update_role'

  get '/groups/:group_id/partecipations/:member_id/update', to: 'partecipations#update', as: 'update'

  get '/groups/:group_id/partecipations/:member_id/invite', to: 'partecipations#invite', as: 'invite'


  get 'partecipations/:id/accept', to: 'partecipations#accept', as: 'accept'
  get 'partecipations/:id/decline', to: 'partecipations#decline', as: 'decline'


  get 'partecipations/:id/destroy', to: 'partecipations#destroy', as: 'destroy_partecipation'
  get 'partecipations/new_role', to: 'partecipations#new_role', as: 'new_role'
  #get '/auth/:provider/callback' => 'sessions#omniauth'

  get '/groups/:group_id/surveys/user_id/new', to: 'surveys#new', as: 'new_survey'
  post '/groups/:group_id/surveys/create', to: 'surveys#create', as: 'new_surveys'
  get '/groups/:group_id/surveys/index', to: 'surveys#index', as: 'index_survey'
  get 'surveys/:id/destroy', to: 'surveys#destroy', as: 'destroy_survey'



  get '/groups/:group_id/surveys/:survey_id/:user_id/invite', to: 'surveys#invite', as: 'invite_survey'
  post '/groups/:group_id/surveys/:survey_id/:user_id/accept', to: 'surveys#answer', as: 'answer_survey'

  get 'surveys/:survey_id/show', to: 'surveys#show', as: 'show_survey'


  get '/groups/:group_id/posts/:id/destroy' , to: 'posts#destroy', as: 'destroy_post'                                                



  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
