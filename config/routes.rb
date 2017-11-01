Rails.application.routes.draw do
  devise_for :admins
  
  necker_landing_paths = %w[voter_participation states_xy active_charts]
  
  necker_landing_paths.each do |necker_path|
    get "/#{necker_path}", to: "landing##{necker_path}", as: necker_path
  end
  
  resources :datasheets, only: %i[index show]
  resources :words, only: %i[index]
  
  namespace :admin do
    resources :datasheets, only: %i[index new show create destroy]
  end

  root 'landing#featured'
end
