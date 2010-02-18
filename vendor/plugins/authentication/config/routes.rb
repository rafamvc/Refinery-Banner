ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.resource :session

  map.namespace(:admin) do |admin|
    admin.resources :users
  end

  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot '/forgot', :controller => 'users', :action => 'forgot'
  map.reset 'reset/:reset_code', :controller => 'users', :action => 'reset'

end
