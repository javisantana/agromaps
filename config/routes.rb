Agromaps::Application.routes.draw do
  resources :maps, :path => 'm'
  match '/municipalities' => 'searchs#municipalities'
  match '/plots' => 'searchs#plots'

  root :to => "site#home"
end
