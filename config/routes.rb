Shepherd::Application.routes.draw do
	root :to => "pages#index"

  # Authentications
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signin' => 'sessions#new'
  get '/signin/:provider' => 'sessions#new'
  get '/signout' => 'sessions#destroy'
  get '/auth/failure' => 'pages#index'

  scope '/api' do

    # Api Access for our app
    #
    get '/me' => 'sessions#me'
    get '/signout' => 'sessions#destroy'

    # Top level reports
    get '/analytics/search' => 'analytics#search'
    get '/analytics/views' => 'analytics#views'
    get '/reports/recent' => 'reports#recent'
    get '/messages' => 'messages#index'
    get '/messages/template' => 'messages#template'
    post '/messages/template' => 'messages#update_template'
    get '/messages/at_subject' => 'messages#at_subject'

    # Users
    get '/users' => 'users#index'
    get '/users/summary' => 'users#summary'
    get '/users/:id' => 'users#show', :constraints => { :id => /[^\/]*/ }
    get '/users/:id/activity' => 'users#activity', :constraints => { :id => /[^\/]*/ }
    get '/providers' => 'users#providers'

    # Lead, local version of User
    get '/leads' => 'leads#index'
    get '/leads/:uid' => 'leads#show', :constraints => { :uid => /[^\/]*/ }
    post '/leads' => 'leads#create'
    post '/leads/:uid' => 'leads#update', :constraints => { :uid => /[^\/]*/ }

    # Notes
    get '/leads/:uid/notes' => 'leads#notes', :constraints => { :uid => /[^\/]*/ }
    get '/notes' => 'notes#reminders'
    post '/notes' => 'notes#create', :constraints => { :uid => /[^\/]*/ }
    post '/notes/:id' => 'notes#update'
    delete '/notes/:id' => 'notes#destroy'

    # Gmail
    get '/gmail/inbox' => 'gmail#inbox'
    get '/gmail/message/:id' => 'gmail#message'
    post '/gmail/message/:uid' => 'gmail#send_message', :constraints => { :uid => /[^\/]*/ }
    get '/gmail/templates' => 'gmail#templates'

    # Campaigns
    get '/campaigns' => 'campaigns#index'
    get '/campaigns/:utm_campaign' => 'campaigns#show'

    # Tasks aka Projects
    get '/tasks' => 'tasks#index'
    get '/tasks/stats' => 'tasks#stats'
    get '/tasks/:id' => 'tasks#summary', :constraints => { :id => /[^\/]*/ }

    # Companies
    get '/companies' => 'companies#index'
    get '/companies/locations' => 'companies#locations'
    get '/companies/:id' => 'companies#show', :constraints => { :id => /[^\/]*/ }
  end

  # Ahoy email tracking routes
  mount AhoyEmail::Engine => "/ahoy"

  # SEO enabled paths for angular routes
  get "*path.html" => "pages#index", :layout => 0
  get "*path", :to => 'pages#index'

end