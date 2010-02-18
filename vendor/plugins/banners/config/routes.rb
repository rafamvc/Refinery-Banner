ActionController::Routing::Routes.draw do |map|
  map.resources :banners, :member => { :gallery => :get }
  map.resources :banners, :member =>  { :banner => :get }
  

  map.namespace(:admin) do |admin|
    admin.resources :banners 
  end
  
end
