class UserController < ApplicationController
  skip_before_action :authenticate_user!, only: [:more_info]
  layout :choose_layout

  def choose_layout
    if current_user.nutrition_only
      "nutrition"
    else
      'nav'
    end
  end

	def new
    @user = User.new
    @measurements = @user.measurements.build
    @regularity = User.regularities
    @goals = User.goals
    @gyms = Gym.all.includes(:users)
    @trainers = current_user.gym.users.trainers
    @workouts = Workout.all
    @current_gym = current_user.gym
    @gym = @current_gym
	end

  def create
    @user = User.new(user_params)
    @user.not_a_robot = true
    @user.password = params[:user][:pin]
    @user.gym = current_user.gym

    #store values in case error
    @measurements = @user.measurements.build
    @regularity = User.regularities
    @goals = User.goals
    @gyms = Gym.all.includes(:users)
    @trainers = current_user.gym.users.trainers
    @workouts = Workout.all
    @current_gym = current_user.gym

    if @user.save
      flash[:notice] = "New User, #{@user.username}, successfully created."
      redirect_to gym_path(current_user.gym_id)
    else
      error_string = ""
      @user.errors.messages.each do |key, messages|
        error_string << "#{key}: " + messages.join(',') + "\n"
      end
      flash[:alert] = error_string
      render new_user_path
    end
  end

  def more_info
    UserMailer.with(user: params[:user]).more_info_email.deliver_now
    redirect_to root_path
  end

  def disable_user
    user = User.find(params[:id])
    user.update(account_disabled: true)

    flash[:notice] = "#{user.first_name} #{user.last_name} was disabled."
    redirect_to gym_path(current_user.gym_id)
  end

  def enable_user
    user =  User.find(params[:id])
    user.update(account_disabled: false)

    flash[:notice] = "#{user.first_name} #{user.last_name} was enabled."
    redirect_to gym_path(current_user.gym_id)
  end

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :pin, :regularity_id, :goal_id, :trainer_id,
                                 :email, :phone_number, :avatar, :medical_concerns, :protein_total, :carb_total,
                                 :fat_total,
      measurements: [:upper_arm, :chest, :waist, :hip, :thigh, :calf, :wrist, :forearm, :left_tricep, :right_tricep,
                     :subscapular, :abdominal, :mid_thigh, :inside_calf, :pec, :left_bicep, :right_bicep, :suprailiac])
  end
end
