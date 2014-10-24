Shepherd::Application.routes.draw do
	root :to => "pages#index"

  # Authentications
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signin' => 'sessions#new'
  get '/signin/:provider' => 'sessions#new'
  get '/signout' => 'sessions#destroy'
  get '/auth/failure' => 'pages#home'

  get '/api/users' => 'users#index'
  get '/api/users/:id' => 'users#show', :constraints => { :id => /[^\/]*/ }

  get '/api/tasks' => 'tasks#index'
  get '/api/tasks/stats' => 'tasks#stats'
  get '/api/tasks/:id' => 'tasks#summary', :constraints => { :id => /[^\/]*/ }

	get "*path.html" => "pages#index", :layout => 0
  get "*path", :to => 'pages#index'
end