Rails.application.routes.draw do
  devise_for :admins
  root 'landing#home'
  
  namespace :admin do
    resources :datasheets, only: %i[index new show create destroy]
  end
end
