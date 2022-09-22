  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users

  ## Maps root of application to articles controller index action
  root "input_texts#index"

  ## Replace these get routes with a resource route that will also generate routes for the other CRUD operations
  ## Get /articles requests are mapped to the index action of the ArticlesController
  #get "/articles", to: "articles#index"
  #get "/article/:id", to: "articles#show"

  ## This is what the automatically generated route looks like, but it's not a map, how does it work?
  # get 'articles/index'  

  #resources :articles ## I think this has to be the pluralized form of a MODEL?

  resources :articles do
    resources :comments
  end

  resources :tokens

  #post "/update_token_table", to: "tokens#update_token_table"

  resources :input_texts do
    resources :shingles
  end

  get '/how_to_use', to: 'static_pages#how_to_use'
  get '/resources', to: 'static_pages#resources'
  get '/how_it_works', to: 'static_pages#how_it_works'



  #Rails.application.routes.draw do
  #  devise_scope :user do
  #    # Redirests signing out users back to sign-in
  #    get "users", to: "devise/sessions#new"
  #  end

  #devise_for :users
  #end

end
