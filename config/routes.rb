Shepherd::Application.routes.draw do
	root :to => "pages#index"

  # Authentications
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signin' => 'sessions#new'
  get '/signin/:provider' => 'sessions#new'
  get '/signout' => 'sessions#destroy'
  get '/auth/failure' => 'pages#home'


  # Api Access for our app
  #
  # Multi-db site selection
  match '/api/site' => 'sessions#change_site', via: [:get, :post]

  # Users
  get '/api/users' => 'users#index'
  get '/api/users/stats' => 'users#stats'
  get '/api/users/:id' => 'users#show', :constraints => { :id => /[^\/]*/ }

  # Lead, local version of User
  get '/api/leads/:uid' => 'leads#show', :constraints => { :uid => /[^\/]*/ }
  post '/api/leads' => 'leads#update', :constraints => { :uid => /[^\/]*/ }

  # Tasks
  get '/api/tasks' => 'tasks#index'
  get '/api/tasks/stats' => 'tasks#stats'
  get '/api/tasks/:id' => 'tasks#summary', :constraints => { :id => /[^\/]*/ }

  # Companies
  get '/api/companies' => 'companies#index'
  get '/api/companies/locations' => 'companies#locations'
  get '/api/companies/:id' => 'companies#show', :constraints => { :id => /[^\/]*/ }

  # SEO enabled paths for angular routes
	get "*path.html" => "pages#index", :layout => 0
  get "*path", :to => 'pages#index'
end