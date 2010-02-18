ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  map.namespace(:admin) do |admin|
    admin.resources :pages
    admin.resources :page_parts

    admin.resources :pages_dialogs, :as => "pages/dialogs", :controller => :page_dialogs,
                    :collection => {:link_to => :get, :test_url => :get, :test_email => :get}
  end
end
