Rails.application.routes.draw do
  devise_for :admins
  
  get '/voter_participation', to: 'landing#voter_participation', as: 'voter_participation'
  
  resources :datasheets, only: %i[index show]
  resources :words, only: %i[index]
  
  namespace :admin do
    resources :datasheets, only: %i[index new show create destroy]
  end

  root 'landing#featured'
end
