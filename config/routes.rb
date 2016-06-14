Rails.application.routes.draw do
  root to: 'static_pages#home'
  resources :user, only: %i(index show)
end
