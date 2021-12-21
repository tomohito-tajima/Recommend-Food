Rails.application.routes.draw do
  # get 'relationships/followings'
  # get 'relationships/followers'
  devise_for :users
  # test
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users, only: %i[show index edit update] do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :foods do
    resources :comments, only: %i[create destroy]
    # お気に入り・いいね機能のネストでルーティング
    get 'likes' => 'likes#index', on: :collection
    post 'add' => 'likes#create'
    delete '/add' => 'likes#destroy'
    # レビュー機能のネストでルーティング
    resources :reviews, only: %i[index create]
  end

  get '/search', to: 'searchs#search'
end
