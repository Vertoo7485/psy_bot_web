Rails.application.routes.draw do
  get 'gratitude_entries/create'
  get 'gratitude_entries/index'
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

  resources :gratitude_entries, only: [:create, :index]

  resources :test_results, only: [:show]

  resources :reflection_entries, only: [:create, :index]
  
  # Главная страница
  root to: 'home#index'
end