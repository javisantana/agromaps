Agromaps::Application.routes.draw do  
  resources :maps, :path => 'm'
  
  root :to => "site#home"
end
