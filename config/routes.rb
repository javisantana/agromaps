Agromaps::Application.routes.draw do
  resources :maps, :path => 'm'
  match '/municipalities' => 'searchs#municipalities'

  root :to => "site#home"
end
