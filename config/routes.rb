  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  ## Routes for devise modules on User
  devise_for :users, :path_prefix => 'd' 

  ## Custom admin-type CRUD for users
  resources :users 

  ## Map root of application
  root "input_texts#index"

  ## My routes
  resources :input_texts do
    resources :shingles
  end
  resources :known_words

  ## Routes to static pages
  get '/how_to_use', to: 'static_pages#how_to_use'
  get '/resources', to: 'static_pages#resources'
  get '/how_it_works', to: 'static_pages#how_it_works'

  ## Other
  get 'tasks/delete_stale_guest_users', to: 'tasks#delete_stale_guest_users'
  post "/known_word_create_ajax", to: "known_words#create_ajax"

end