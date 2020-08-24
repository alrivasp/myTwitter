Rails.application.routes.draw do
  resources :tweets do
    #      ruta     donde ira
    post 'likes', to: 'tweets#likes'
    post 'retweet', to: 'tweets#retweet'
  end

  #devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
