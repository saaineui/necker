Rails.application.routes.draw do
  devise_for :admins
  
  get '/voter_participation', to: 'landing#voter_participation', as: 'voter_participation'
  get '/states_xy', to: 'landing#states_xy', as: 'states_xy'
  get '/books_xy', to: 'landing#books_xy', as: 'books_xy'
  get '/words_line', to: 'landing#words_line', as: 'words_line'
  
  resources :datasheets, only: %i[index show]
  resources :words, only: %i[index]
  
  namespace :admin do
    resources :datasheets, only: %i[index new show create destroy]
  end

  root 'landing#featured'
end
