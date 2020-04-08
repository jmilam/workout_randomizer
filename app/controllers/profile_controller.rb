class ProfileController < ApplicationController
  def index
    @user = current_user
    @gym = @user.gym
    @title = "#{@user.first_name} Profile"
    @workout_group = WorkoutGroup.find_by(id: @user.current_workout_group)

    
    @workout = Workout.find(@user.current_workout) unless @user.current_workout.nil?

    @height = (@user.height / 12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)

    @wod = Wod.where(gym_id: @user.gym.id, workout_date: Date.today).last
  end

  def edit
    @user = User.find(params[:id])
    @user_goals = @user.goals
    @measurements = @user.measurements.last || @user.measurements.new
    @regularity = User.regularities
    @goals = User.goals
    @gym = @user.gym
    @gyms = Gym.all.includes(:users)
    @trainers = @user.gym.users.trainers
    @workouts = @user.gym.workouts
    @workout_groups = @user.gym.workout_groups.uniq
    @gym_admin = !GymAdmin.where(gym_id: @user.gym.id, user_id: @user.id).empty?
  end

  def update
    @user = User.find(params[:id])

    @user.gym.update_gym_admin(params[:gym_admin], @user.id)

    if @user.update!(workout_params)
      @user.update_goals(params[:goal])
      flash[:notice] = 'User successfully updated'
    else
      flash[:alert] = "Errors on update #{@user.errors}"
    end
    redirect_to edit_profile_path(@user.id)
  end

  protected

  def workout_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :regularity_id, :goal_id, :trainer_id, :trainer,
                                 :gym_id, :current_workout, :avatar, :medical_concerns, :current_workout_group, :email, :employee,
        measurements_attributes: [:upper_arm, :chest, :waist, :hip, :thigh, :calf, :wrist, :forearm, :left_tricep, :right_tricep,
      :subscapular, :abdominal, :mid_thigh, :inside_calf, :pec, :left_bicep, :right_bicep, :suprailiac])
  end
end
