class KioskController < ApplicationController
  layout 'nav'
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
      @user = current_user
      @workout = Workout.find(@user.current_workout)
      

      if @workout.user_worked_out_today?
      else
      end

      # if @user.current_workout.nil?
      #   p "WORKOUT nil"
      #   # Find Workouts matching user designated goals
      #   workouts_by_matching_goal = @user.gym.workouts.includes(:category).where(categories: {goal_id:  @user.goal_id})
      #   # Sort workouts by most liked, for best results
      #   sorted_workouts = Workout.sort_by_likes(current_user, workouts_by_matching_goal)
      #   # Get Workout Group IDS
      #   workout_group_ids = @user.user_previous_workouts.map(&:workout_group_id).uniq
      #   # Validate previous workout ids by the Workout Group IDs
      #   previous_workout_ids = workout_group_ids.map { |group_id| WorkoutGroup.find(group_id).workout&.id }.uniq
      #   # Delete workout from results if user has already done the workout
      #   sorted_workouts.delete_if { |workout| previous_workout_ids.include?(workout&.id)}
      #   # Select best workout for user
      #   @workout = sorted_workouts.empty? ? @user.gym.workouts.sample : sorted_workouts[0]
      #   # Assign workout to user
      #   @user.update(current_workout: @workout&.id,
      #                current_workout_group: @workout&.workout_groups.sample.id)
      # else
      #   @workout = Workout.find(@user.current_workout)
      #   workouts_complete = WorkoutDetail
      #     .where(workout_date: Date.today.beginning_of_week.strftime('%Y-%m-%d')..Date.today.end_of_week.strftime('%Y-%m-%d'),
      #            user_id: @user.id)
      #     .uniq
      #     # .map(&:workout_group_id)

      #   if @user.current_workout_group.nil? && WorkoutDetail.where(workout_date: Date.today.strftime('%Y-%m-%d'), user_id: @user.id).empty?
      #     # Workout Group specified for today?
      #     todays_workout = nil
      #     # todays_workout = WorkoutGroupSpecifiedDay
      #       # .where(workout_group_id: Workout.find(User.first.current_workout)&.workout_groups.map(&:id),
      #              # workout_day_num: Date.today.wday).last


      #     if todays_workout.nil?
      #       # Assign random workout not associated to day
      #       available_workout_groups = Workout.find(current_user.current_workout).workout_groups.to_a.delete_if { |workout_group| workouts_complete.include?(workout_group.id) }
  
      #       workouts_on_specific_day = WorkoutGroupSpecifiedDay
      #         .where(workout_group_id: Workout.find(User.first.current_workout)&.workout_groups.map(&:id))

      #       available_workout_groups.delete_if do |workout_group|
      #         (available_workout_groups.map(&:id) & workouts_on_specific_day.map(&:workout_group_id)).include?(workout_group.id)
      #       end
            
      #       @user.update!(current_workout_group: available_workout_groups.sample.id)
      #     else
      #       # Validate if workout has been completed?
      #       if UserPreviousWorkout.where(workout_group_id: todays_workout.id,
      #                                    workout_date: Date.today.in_time_zone(Gym.first.time_zone).strftime('%Y-%m-%d')).empty?
      #         @user.update!(current_workout_group: todays_workout.workout_group_id)
      #       end
      #     end
      #   elsif @user.current_workout_group.nil?
      #     return
      #   end
      # end
      @last_workout = @workout.workout_details.where(user_id: @user.id) unless @workout.nil?
      @exercise_groups = Exercise.group_by_circuit(@workout)
      exercise_complete_count = @workout.workout_details.where(workout_date: Date.today.strftime('%Y-%m-%d')).count.to_f
      exercise_count = @workout.exercises.count.to_f

      @complete_percent = ((exercise_complete_count / exercise_count) * 100).to_i
      @step_string = "#{exercise_complete_count.to_i} of #{exercise_count.to_i}"
      @exercise_group = Exercise.get_exercise(current_user, @exercise_groups)
      @button_title = "Next Exercise"
    # rescue StandardError => error
    #   flash[:alert] = "THERE WAS AN ERROR: #{error}"
    end
  end

  def log_exercise
    WorkoutDetail.transaction do
      # begin
        user_id = params.dig(:exercises, :user_id)
        user = user_id.blank? ? current_user : User.find(user_id)

        workout_date = params[:exercises][:workout_date].blank? ? Date.today.in_time_zone :
          params[:exercises][:workout_date]
          workout_id = params[:exercises][:workout_detail].first[:workout_id].blank? ?
          user.current_workout_id: params[:exercises][:workout_detail].first[:workout_id].to_i

          workout = user.current_workout.nil? ? Workout.find(workout_id) : Workout.find(user.current_workout)

         prev_workout = user.user_previous_workouts.find_or_create_by!(
           workout_id: workout.id,
           workout_date: workout_date
         )

         params[:exercises][:workout_detail].each do |details|
           next if details['rep_1_weight'].blank?

           prev_workout.workout_details.new(details.permit!)
           workout_details = prev_workout.workout_details.create(details.permit!)
           workout_details.update!(user_id: user.id)
         end

         exercise_groups = Exercise.group_by_circuit(workout)
         no_more_exercises = Exercise.get_exercise(user, exercise_groups).nil?
         user.update(current_workout_group: nil) if no_more_exercises
         flash[:notice] = user.current_workout_group.nil? ? 'Great Workout! You completed todays workout!' : 'Exercise Complete'

         if !user.trainer_id.nil? && no_more_exercises
            trainer = User.find(user.trainer_id)
            message_group = user.inbox.message_groups.find_or_create_by(subject: "How was the workout today?")
            message_group.messages.create!(detail: "Saw you got your workout in today, any problem areas I can help with?",
                                       user_id: trainer.id)
          end
        if params[:exercises][:workout_detail].first[:workout_group_id].blank?
          redirect_to kiosk_exercise_path
        elsif params[:exercises][:manual_entry] == "true"
          redirect_to manual_workout_path
        else
          redirect_to kiosk_exercise_path workout_group_id: workout_group_id
        end
       # rescue StandardError => error

       #   flash[:alert] = "There was an error when saving Workout Details #{error}"
       # end
    end
  end

  private

  def kiosk_params
    params.require(:kiosk).permit(:gym_id, :kiosk_number, :exercise_id)
  end
end
