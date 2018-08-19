Rails.application.routes.draw do
  get 'kiosk/index', to: 'kiosk#index', as: 'kiosk'
  get 'kiosk/configure_exercise', to: 'kiosk#configure_exercise', as: 'kiosk_exercise'
  post 'kiosk/login', to: 'kiosk#login', as: 'kiosk_login'
  post 'kiosk/create', to: 'kiosk#create', as: 'create_kiosk'
  post 'kiosk/log_exercise', to: 'kiosk#log_exercise', as: 'log_exercise'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'workout/list', to: 'workout#list', as: 'list_workouts'
  post 'workout/accept_deny_workout', to: 'workout#accept_deny_workout', as: 'accept_deny_workout'
  patch 'workout/accept_workout', to: 'workout#accept_workout', as: 'accept_workout'
  patch 'workout/stop_workout', to: 'workout#stop_workout', as: 'stop_workout'

  get 'workout_detail/index', to: 'workout_detail#index', as: 'workout_history'
  post 'workout_detail/create', to: 'workout_detail#create', as: 'create_workout_detail'

  post 'workout/like_workout', to: 'workout#like_workout', as: 'like_workout'

  resources :profile
  resources :workout
  resources :exercise
  resources :workout_group
  resources :category
  resources :inbox
  resources :message
  resources :message_group
  resources :gym

  root to: 'profile#index'
end
