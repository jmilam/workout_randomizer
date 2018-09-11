class KioskController < ApplicationController
  skip_before_action :authenticate_user!
  def index
  end

  def create
    @kiosk = Kiosk.new(kiosk_params)

    if @kiosk.save
      flash[:notice] = 'Kiosk successfully created'
    else
      flash[:error] = "Error when creating kiosk: #{@kiosk.errors}"
    end
    redirect_to gym_path(@kiosk.gym_id)
  end

  def login
    user = User.find_by(pin: params[:pin])

    sign_in user

    flash[:notice] = 'Welcome, lets get after it.'
    redirect_to kiosk_exercise_path
  end

  def configure_exercise
    begin
      # find current workout
      @user = current_user

      if @user.current_workout.nil?
        # Find Workouts matching user designated goals
        workouts_by_matching_goal = @user.gym.workouts.includes(:category).where(categories: {goal_id:  @user.goal_id})
        # Sort workouts by most liked, for best results
        sorted_workouts = Workout.sort_by_likes(current_user, workouts_by_matching_goal)
        # Get Workout Group IDS
        workout_group_ids = @user.user_previous_workouts.map(&:workout_group_id).uniq
        # Validate previous workout ids by the Workout Group IDs
        previous_workout_ids = workout_group_ids.map { |group_id| WorkoutGroup.find(group_id).workout.id }.uniq
        # Delete workout from results if user has already done the workout
        sorted_workouts.delete_if { |workout| previous_workout_ids.include?(workout.id)}
        # Select best workout for user
        @workout = sorted_workouts.empty? ? @user.gym.workouts.sample : sorted_workouts[0]
        # Assign workout to user
        @user.update(current_workout: @workout.id,
                     current_workout_group: @workout.workout_groups.sample.id)
      else
        @workout = Workout.find(current_user.current_workout)
        workouts_complete = WorkoutDetail
          .where(workout_date: Date.today.beginning_of_week.strftime('%Y-%m-%d')..Date.today.end_of_week.strftime('%Y-%m-%d'),
                 user_id: @user.id)
          .map(&:workout_group_id)
          .uniq

        if @user.current_workout_group.nil? && WorkoutDetail.where(workout_date: Date.today.strftime('%Y-%m-%d'), user_id: @user.id).empty?
          current_workout_groups = @workout.workout_groups.to_a.delete_if { |workout_group| workouts_complete.include?(workout_group.id) }
          
          idx = current_workout_groups.index { |workout_group| WorkoutGroup.day_of_the_weeks[workout_group.day] == Date.today.strftime('%A')}
          group_id = if idx.nil?
                       current_workout_groups.sample.id
                     else
                       current_workout_groups[idx].id
                     end
          @user.update(current_workout_group: group_id)
        elsif @user.current_workout_group.nil?
          return
        end
      end

      @workout_group = WorkoutGroup.find(@user.current_workout_group)
      @last_workout = @workout_group.workout_details.where(user_id: @user.id) unless @workout_group.nil?
      @exercise_groups = Exercise.group_by_circuit(@workout_group)
      exercise_complete_count = @workout_group.workout_details.where(workout_group_id: @workout_group.id, workout_date: Date.today.strftime('%Y-%m-%d')).count.to_f
      exercise_count = @workout_group.exercises.count.to_f

      @complete_percent = ((exercise_complete_count / exercise_count) * 100).to_i
      @step_string = "#{exercise_complete_count.to_i} of #{exercise_count.to_i} complete"
      @exercise_group = Exercise.get_exercise(current_user, @exercise_groups)
    rescue StandardError => error
      flash[:alert] = "THERE WAS AN ERROR: #{error}"
    end
  end

  def log_exercise
    WorkoutDetail.transaction do
      begin
         workout = Workout.find(current_user.current_workout)
         workout_group = WorkoutGroup.find(current_user.current_workout_group)
         workout_date = Date.today.in_time_zone
         reference_exercise = Exercise.find(params[:exercises][:workout_detail].first[:exercise_id])

         prev_workout = current_user.user_previous_workouts.find_or_create_by!(
           workout_group_id: reference_exercise.workout_group_id,
           workout_date: Date.today.in_time_zone
         )

         params[:exercises][:workout_detail].each do |details|
           next if details['rep_1_weight'].blank?
           prev_workout.workout_details.new(details.permit!)
           workout_details = prev_workout.workout_details.create(details.permit!)
           workout_details.update!(user_id: current_user.id)
         end

         exercise_groups = Exercise.group_by_circuit(workout_group)

         current_user.update(current_workout_group: nil) if Exercise.get_exercise(current_user, exercise_groups).nil?
         flash[:notice] = current_user.current_workout_group.nil? ? 'Great Workout! You completed todays workout!' : 'Exercise Complete'
         redirect_to kiosk_exercise_path
       rescue StandardError => error
         flash[:alert] = "There was an error when saving Workout Details #{error}"
       end
    end
  end

  private

  def kiosk_params
    params.require(:kiosk).permit(:gym_id, :kiosk_number, :exercise_id)
  end
end
