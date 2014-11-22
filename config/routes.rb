Shepherd::Application.routes.draw do
	root :to => "pages#index"

  # Authentications
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signin' => 'sessions#new'
  get '/signin/:provider' => 'sessions#new'
  get '/signout' => 'sessions#destroy'
  get '/auth/failure' => 'pages#index'
  get '/api/me' => 'sessions#me'

  # Api Access for our app
  #
  get '/api/signout' => 'sessions#destroy'
  # Multi-db site selection
  match '/api/site' => 'sessions#change_site', via: [:get, :post]

  # Top level reports
  get '/reports/recent' => 'reports#recent'

  # Users
  get '/api/users' => 'users#index'
  get '/api/users/:id' => 'users#show', :constraints => { :id => /[^\/]*/ }
  get '/api/users/:id/activity' => 'users#activity', :constraints => { :id => /[^\/]*/ }

  # Lead, local version of User
  get '/api/leads/:uid' => 'leads#show', :constraints => { :uid => /[^\/]*/ }
  post '/api/leads' => 'leads#create'
  post '/api/leads/:uid' => 'leads#update', :constraints => { :uid => /[^\/]*/ }

  # Notes
  get '/api/leads/:uid/notes' => 'leads#notes', :constraints => { :uid => /[^\/]*/ }
  get '/api/notes' => 'notes#reminders'
  post '/api/notes' => 'notes#create', :constraints => { :uid => /[^\/]*/ }
  post '/api/notes/:id' => 'notes#update'
  delete '/api/notes/:id' => 'notes#destroy'

  # Gmail
  get '/api/gmail/inbox' => 'gmail#inbox'
  get '/api/gmail/message/:id' => 'gmail#message'
  post '/api/gmail/message/:uid' => 'gmail#send_message', :constraints => { :uid => /[^\/]*/ }
  get '/api/gmail/templates' => 'gmail#templates'

  # Tasks aka Projects
  get '/api/tasks' => 'tasks#index'
  get '/api/tasks/stats' => 'tasks#stats'
  get '/api/tasks/:id' => 'tasks#summary', :constraints => { :id => /[^\/]*/ }

  # Companies
  get '/api/companies' => 'companies#index'
  get '/api/companies/locations' => 'companies#locations'
  get '/api/companies/:id' => 'companies#show', :constraints => { :id => /[^\/]*/ }

  # Ahoy email tracking routes
  mount AhoyEmail::Engine => "/ahoy"

  # SEO enabled paths for angular routes
	get "*path.html" => "pages#index", :layout => 0
  get "*path", :to => 'pages#index'

end