Rails.application.routes.draw do
  devise_for :users
  # test
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users, :only => [:show, :index, :edit, :update]
  resources :foods do
    resource :favorites, only: [:create, :destroy, :index]
    resources :book_comments, only: [:create, :destroy]
  end
  
  get '/search', to: 'searchs#search'
  
  
end
