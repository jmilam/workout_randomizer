Rails.application.routes.draw do
  get 'goal/index'

  get 'admin_portal/index', to: 'admin_portal#index', as: 'admin_portal' 
  get 'admin_portal/report_data', to: 'admin_portal#report_data' 

  get 'home/index', to: 'home#index'
  get 'kiosk/index', to: 'kiosk#index', as: 'kiosk'
  get 'kiosk/configure_exercise', to: 'kiosk#configure_exercise', as: 'kiosk_exercise'
  post 'kiosk/login', to: 'kiosk#login', as: 'kiosk_login'
  post 'kiosk/create', to: 'kiosk#create', as: 'create_kiosk'
  post 'kiosk/log_exercise', to: 'kiosk#log_exercise', as: 'log_exercise'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'workout/list', to: 'workout#list', as: 'list_workouts'
  get 'workout/manual_workout', to: 'workout#manual_workout', as: 'manual_workout'
  post 'workout/accept_deny_workout', to: 'workout#accept_deny_workout', as: 'accept_deny_workout'
  patch 'workout/accept_workout', to: 'workout#accept_workout', as: 'accept_workout'
  patch 'workout/stop_workout', to: 'workout#stop_workout', as: 'stop_workout'

  get 'workout_detail/index', to: 'workout_detail#index', as: 'workout_history'
  post 'workout_detail/create', to: 'workout_detail#create', as: 'create_workout_detail'

  post 'workout/like_workout', to: 'workout#like_workout', as: 'like_workout'

  put 'category/disable_category', to: 'category#disable_category', as: 'disable_category'
  put 'category/enable_category', to: 'category#enable_category', as: 'enable_category'

  get 'wod/new', to: 'wod#new', as: 'new_wod'
  post 'wod/create', to: 'wod#create', as: 'create_wod'

  get 'blog/index', to: 'blog#index'

  get 'home/blog', to: 'home#blog', as: 'blog'
  get 'home/assessment', to: 'home#assessment', as: 'assessment'
  get 'goal/index', to: 'goal#index', as: 'goal'
  post 'goal/create', to: 'goal#create', as: 'create_goal'
  delete 'goal/:id', to: 'goal#destroy', as: 'delete_goal'

  resources :profile
  resources :workout
  resources :exercise
  resources :workout_group
  resources :category
  resources :inbox
  resources :message
  resources :message_group
  resources :gym
  resources :user

  put 'user/disable_user/:id', to: 'user#disable_user', as: 'disable_user'
  put 'user/enable_user/:id', to: 'user#enable_user', as: 'enable_user'

  get 'workout_group/workout_groups_by_workout/:id', to: 'workout_group#workout_groups_by_workout', as: 'workout_groups_by_workout'

  get 'exercise/get_all_for_workout_group/:id', to: 'exercise#get_all_for_workout_group', as: 'exercises_by_workout_group'
  
  post 'user/more_info', to: 'user#more_info', as: 'more_info'
  # root to: 'profile#index'
  root to: 'home#index'
end
