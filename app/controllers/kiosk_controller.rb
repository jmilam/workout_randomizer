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
      workout_id = params[:workout_id] || (@user.current_workout || @user.current_workout_group)
      @workout = Workout.find(workout_id)

      if @workout.user_worked_out_today?
      else
      end

      @last_workout = @workout.workout_details.where(user_id: @user.id) unless @workout.nil?
      @exercise_groups = Exercise.group_by_circuit(@workout)
      exercise_complete_count = @workout.workout_details.where(workout_date: Date.today.strftime('%Y-%m-%d')).count.to_f
      exercise_count = @workout.exercises.count.to_f

      @complete_percent = ((exercise_complete_count / exercise_count) * 100).to_i
      @step_string = "#{exercise_complete_count.to_i} of #{exercise_count.to_i}"
      @exercise_group = Exercise.get_exercise(current_user, @exercise_groups)
      @button_title = "Next Exercise >>"
    rescue StandardError => error
      flash[:alert] = "THERE WAS AN ERROR: #{error}"
    end
  end

  def log_exercise
    WorkoutDetail.transaction do
      begin
        user_id = params.dig(:exercises, :user_id)
        user = user_id.blank? ? current_user : User.find(user_id)

        workout_date = params[:exercises][:workout_date].blank? ? Date.today.in_time_zone : params[:exercises][:workout_date]
        workout_id = params[:exercises][:workout_detail].first[:workout_id].blank? ?
        user.current_workout_id: params[:exercises][:workout_detail].first[:workout_id].to_i

        workout = user.current_workout.nil? ? Workout.find(workout_id) : Workout.find(user.current_workout)

        prev_workout = user.user_previous_workouts.find_or_create_by!(
          workout_id: workout.id,
          workout_date: workout_date
        )

         params[:exercises][:workout_detail].each do |details|
           next if details['rep_1_weight'].blank?

           workout_details = prev_workout.workout_details.create(details.permit!)
           workout_details.update!(user_id: user.id, workout_date: workout_date)
         end

         exercise_groups = Exercise.group_by_circuit(workout)
         no_more_exercises = Exercise.get_exercise(user, exercise_groups).nil?
         user.update(current_workout: nil) if no_more_exercises
         flash[:notice] = user.current_workout_group.nil? ? 'Great Workout! You completed todays workout!' : 'Exercise Complete'

         if !user.trainer_id.nil? && no_more_exercises
            trainer = User.find(user.trainer_id)
            message_group = user.inbox.message_groups.find_or_create_by(subject: "How was the workout today?")
            message_group.messages.create!(detail: "Saw you got your workout in today, any problem areas I can help with?",
                                       user_id: trainer.id)
          end
        if params[:exercises][:workout_detail].first[:workout_id].blank?
          redirect_to kiosk_exercise_path
        elsif params[:exercises][:manual_entry] == "true"
          redirect_to manual_workout_path
        else
          redirect_to kiosk_exercise_path workout_id: workout_id
        end
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
