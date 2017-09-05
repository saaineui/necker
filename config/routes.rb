Rails.application.routes.draw do
  devise_for :admins
  
  resources :datasheets, only: %i[index show]
  
  namespace :admin do
    resources :datasheets, only: %i[index new show create destroy]
  end

  root 'datasheets#index'
end
