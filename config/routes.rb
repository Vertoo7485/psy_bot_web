Rails.application.routes.draw do
  devise_for :users
  get 'profile', to: 'profile#show'
  
  # Главная страница
  root to: 'home#index'
end