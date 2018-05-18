Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'workout/list', to: 'workout#list', as: 'list_workouts'
  post 'workout/accept_deny_workout', to: 'workout#accept_deny_workout', as: 'accept_deny_workout'
  patch 'workout/stop_workout', to: 'workout#stop_workout', as: 'stop_workout'

  get 'workout_detail/index', to: 'workout_detail#index', as: 'workout_history'
  post 'workout_detail/create', to: 'workout_detail#create', as: 'create_workout_detail'

  resources :profile
  resources :workout
  resources :exercise
  resources :workout_group
  resources :category

  root to: 'profile#index'
end
