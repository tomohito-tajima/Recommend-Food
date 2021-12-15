Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
  devise_for :users
  # test
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users, only: %i[show index edit update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :foods do
    resource :favorites, only: %i[index create destroy]
    resources :book_comments, only: %i[create destroy]
    get 'likes' => 'likes#index'
    post 'add' => 'likes#create'
    delete '/add' => 'likes#destroy'
  end

  get '/search', to: 'searchs#search'
end
