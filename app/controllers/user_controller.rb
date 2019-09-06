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
    p @user = User.new(user_params)
  end

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :regularity_id, :goal_id, :trainer_id,
      measurements: [:upper_arm, :chest, :waist, :hip, :thigh, :calf, :wrist, :forearm, :left_tricep, :right_tricep,
                     :subscapular, :abdominal, :mid_thigh, :inside_calf, :pec, :left_bicep, :right_bicep, :suprailiac])
  end
end
