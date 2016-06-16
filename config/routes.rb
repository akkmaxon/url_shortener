Rails.application.routes.draw do
  get 'search_results' => 'search#search_results'
  get 'search/original'
  get 'search/short'
  get 'search/description'
  get 'search/everywhere'

  resources :urls
  get '/:short' => 'urls#show'

  devise_for :users

  root 'urls#new'
end
