Rails.application.routes.draw do
  get 'goal/index'

  get 'admin_portal/new_users', to: 'admin_portal#new_users', as: 'admin_portal_new_users' 
  get 'admin_portal/time_cards', to: 'admin_portal#time_cards', as: 'admin_portal_time_cards' 
  get 'admin_portal/report_data', to: 'admin_portal#report_data' 
  get 'admin_portal/update_users', to: 'admin_portal#update_users' 

  get 'home/index/:gym', to: 'home#index'
  get 'kiosk/index', to: 'kiosk#index', as: 'kiosk'
  get 'kiosk/configure_exercise', to: 'kiosk#configure_exercise', as: 'kiosk_exercise'
  post 'kiosk/login', to: 'kiosk#login', as: 'kiosk_login'
  post 'kiosk/create', to: 'kiosk#create', as: 'create_kiosk'
  post 'kiosk/log_exercise', to: 'kiosk#log_exercise', as: 'log_exercise'

  devise_for :users, skip: [:sessions, :registrations]

  devise_scope :user do
    # sessions
    get    'login/:gym',  to: 'users/sessions#new',     as: :new_user_session, :defaults => { :gym => "boomslangfitness" }
    post   'login/:gym',  to: 'users/sessions#create',  as: :user_session, :defaults => { :gym => "boomslangfitness" }
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session
    # registrations
    post   '/signup/:gym',  to: 'users/registrations#create', :defaults => { :gym => "boomslangfitness" }
    get    '/signup/:gym', to: 'users/registrations#new',    as: :new_user_registration, :defaults => { :gym => "boomslangfitness" }
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'workout/list', to: 'workout#list', as: 'list_workouts'
  get 'workout/manual_workout', to: 'workout#manual_workout', as: 'manual_workout'
  post 'workout/accept_deny_workout', to: 'workout#accept_deny_workout', as: 'accept_deny_workout'
  patch 'workout/accept_workout', to: 'workout#accept_workout', as: 'accept_workout'
  patch 'workout/stop_workout', to: 'workout#stop_workout', as: 'stop_workout'
  put 'workout/add_exercise', to: 'workout#add_exercise', as: 'add_exercise'

  get 'workout_detail/index', to: 'workout_detail#index', as: 'workout_history'

  post 'workout/like_workout', to: 'workout#like_workout', as: 'like_workout'

  put 'category/disable_category', to: 'category#disable_category', as: 'disable_category'
  put 'category/enable_category', to: 'category#enable_category', as: 'enable_category'

  get 'wod/new', to: 'wod#new', as: 'new_wod'
  post 'wod/create', to: 'wod#create', as: 'create_wod'

  get 'home/blog', to: 'home#blog', as: 'blog'
  get 'home/assessment', to: 'home#assessment', as: 'assessment'
  get 'home/target_heart_rate_calculator', to: 'home#target_heart_rate_calculator', as: 'target_heart_rate_calculator'
  get 'goal/index', to: 'goal#index', as: 'goal'
  post 'goal/create', to: 'goal#create', as: 'create_goal'
  delete 'goal/:id', to: 'goal#destroy', as: 'delete_goal'

  put 'workout_group/add_workout', to: 'workout_group#add_workout', as: 'add_workout'
  get 'workout_group/workout_groups_by_workout/:id', to: 'workout_group#workout_groups_by_workout', as: 'workout_groups_by_workout'

  get 'exercise/get_all_for_workout_group', to: 'exercise#get_all_for_workout_group', as: 'exercises_by_workout_group'
  post 'exercise/add_exercise_to_workout', to: 'exercise#add_exercise_to_workout', as: 'add_exercise_to_workout'

  get 'task/check_if_select_client', to: 'task#check_if_select_client', as: 'check_if_select_client'

  post 'common_exercise/create', to: 'common_exercise#create', as: 'create_common_exercise'
  get 'common_exercise/edit/:id', to: 'common_exercise#edit', as: 'edit_common_exercise'
  patch 'common_exercise/update', to: 'common_exercise#update', as: 'updated_common_exercise'

  delete 'daily_log/destroy_daily_log_food/:id', to: 'daily_log#destroy_daily_log_food', as: 'destroy_daily_log_food'
  get 'food/find_food_by_category', to: 'food#find_food_by_category', as: 'find_food_by_category'
  get 'nutrition_only/:gym', to: 'nutrition_only#index', as: 'nutrition_only_index'
  get 'nutrition_only/overview/:gym', to: 'nutrition_only#overview', as: 'nutrition_only_overview'
  post 'nutrition_only/create', to: 'nutrition_only#create', as: 'create_nutrition_only'

  get 'daily_log/edit_daily_log_foods/:id', to: 'daily_log#edit_daily_log_foods', as: 'edit_daily_log_foods'
  get 'food/search', to: 'food#search'
  get 'food_group/add_meal', to: 'food_group#add_meal'

  get 'meal/index', to: 'meal#index', as: 'meal'

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
  resources :task
  resources :time_card
  resources :food
  resources :daily_log
  resources :food_group

  put 'user/disable_user/:id', to: 'user#disable_user', as: 'disable_user'
  put 'user/enable_user/:id', to: 'user#enable_user', as: 'enable_user'
  
  post 'user/more_info', to: 'user#more_info', as: 'more_info'

  get 'home/ad', to: 'home#ad', as: 'home_ad'
  get '/:gym', to: 'home#index'
  post 'user_note/create', to: 'user_note#create', as: 'create_user_note'
  # root to: 'profile#index'
  root to: 'home#index'
end
