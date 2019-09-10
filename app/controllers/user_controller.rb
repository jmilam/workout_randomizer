class UserController < ApplicationController
  layout 'onboarding'
	def new
    @user = User.new
    @measurements = @user.measurements.build
    @regularity = User.regularities
    @goals = User.goals
    @gyms = Gym.all.includes(:users)
    @trainers = current_user.gym.users.trainers
    @workouts = Workout.all
    @current_gym = current_user.gym
	end

  def create
    @user = User.new(user_params)
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

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :pin, :regularity_id, :goal_id, :trainer_id,
                                 :email, :phone_number,
      measurements: [:upper_arm, :chest, :waist, :hip, :thigh, :calf, :wrist, :forearm, :left_tricep, :right_tricep,
                     :subscapular, :abdominal, :mid_thigh, :inside_calf, :pec, :left_bicep, :right_bicep, :suprailiac])
  end
end
