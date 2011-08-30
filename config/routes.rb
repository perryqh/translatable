Translatable::Application.routes.draw do
  resources :translations

  root :to => "translations#index"
end
