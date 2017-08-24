Rails.application.routes.draw do
  devise_for :admins
  root 'landing#home'
end
