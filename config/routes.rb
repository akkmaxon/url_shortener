Rails.application.routes.draw do
  resources :urls
  get '/:short' => 'urls#show'

  devise_for :users

  root 'urls#new'
end
