Rails.application.routes.draw do
  get 'static/install'
  get 'payments/create'
  get 'payments/success'
  get 'push_subscriptions/create'
  get 'support/new'
  get 'support/create'
  get 'start/index'
  get 'premium/index'
  get 'reflection_answers/create'
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
      post 'reset', to: 'programs#reset'  # ← добавить эту строку
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :show, :edit, :update]
    resources :support_messages, only: [:index, :show, :destroy]
  end

  resources :gratitude_entries, only: [:create, :index]

  resources :test_results, only: [:show]

  resources :reflection_entries, only: [:create, :index]

  resources :anxious_thought_entries, only: [:create, :index]

  resources :emotion_diary_entries, only: [:create, :index]

  get 'emotion_diary/new', to: 'emotion_diary#new', as: 'new_emotion_diary'
  post 'emotion_diary', to: 'emotion_diary#create'

  resources :grounding_exercise_entries, only: [:create, :index]
  resources :self_compassion_practices, only: [:create, :index]
  resources :procrastination_tasks, only: [:create, :index]
  resources :kindness_entries, only: [:create, :index]
  resources :reconnection_practices, only: [:create, :index]
  resources :compassion_letters, only: [:create, :index]
  resources :pleasure_activities, only: [:create, :index, :update]
  resources :meditation_sessions, only: [:create, :index]
  resources :fear_conquests, only: [:create, :index]
  resources :reflection_answers, only: [:create]
  get 'premium', to: 'premium#index'
  get 'start', to: 'start#index'
  get 'support', to: 'support#new'
  post 'support', to: 'support#create'

  post 'payments/create', to: 'payments#create'
  get 'payments/success', to: 'payments#success'
  post 'webhook/yookassa', to: 'webhook#yookassa'

  get 'install', to: 'static#install'

resources :push_subscriptions, only: [:create] do
  collection do
    post 'test'
  end
end
  
  # Главная страница
  root to: 'home#index'
end
