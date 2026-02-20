Rails.application.routes.draw do
  get 'programs/index'
  get 'programs/show'
  get 'programs/start'
  get 'programs/day'
  get 'test_results/show'
  get 'tests/index'
  get 'tests/show'
  devise_for :users
  get 'profile', to: 'profile#show'

  resources :tests, only: [:index, :show] do
    member do
      get 'start'
      get 'submit' 
      post 'submit'
      post 'question', to: 'tests#question'
      get 'question', to: 'tests#question'
    end
  end

  resources :programs, only: [:index, :show] do
    member do
      get 'day/:day_number', to: 'programs#day', as: :day
      post 'day/:day_number/complete', to: 'programs#complete_day'
    end
  end

  resources :test_results, only: [:show]
  
  # Главная страница
  root to: 'home#index'
end