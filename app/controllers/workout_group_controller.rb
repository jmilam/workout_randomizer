class WorkoutGroupController < ApplicationController
  layout 'nav'
  def index
  end

  def new
    @workouts = current_user.gym.workouts
    @workout_group = WorkoutGroup.new
  end

  def edit
    @workout_group = WorkoutGroup.find(params[:id])
    @workout_users = User.where(current_workout_group: @workout_group.id)
    @workouts = current_user.gym.workout_group_pairings.map { |pairing| [pairing.workout, WorkoutGroup.day_of_the_weeks[pairing.workout_day]] }
  end

  def create
    WorkoutGroup.transaction do
      begin
        @workout_group = WorkoutGroup.new(workout_group_params)
        @workout_group.save!

        params[:selected_workout_ids].split(',').zip(params[:selected_workout_day_ids].split(',')).each do |workout_grouping|
          @workout_group_pairing = current_user.gym.workout_group_pairings.create!(workout_group: @workout_group,
                                                               workout_id: workout_grouping[0],
                                                               workout_day: workout_grouping[1])
        end

        flash[:notice] = "Workout Group #{@workout_group.name} was successfully created."
        redirect_to gym_path(current_user.gym.id)
      rescue ActiveRecord::RecordInvalid => error
        flash[:alert] = "There was an error when updating exercise: #{error}"
        render :new
      end
    end
  end

  def add_workout
    @selected_workout_ids = params[:selected_workout_ids]&.split(',') || []
    @selected_workout_day_ids = params[:selected_workout_day_ids]&.split(',') | []

    @selected_workout_ids << params[:workout]
    @selected_workout_day_ids << params[:workout_day]

    @selected_workouts = []
    @selected_workout_ids.zip(@selected_workout_day_ids).each do |workout_grouping|
      @selected_workouts << { workout_name: Workout.find(workout_grouping[0]).name, workout_day: WorkoutGroup.day_of_the_weeks[workout_grouping[1].to_i] }
    end
  end

  def update
    WorkoutGroup.transaction do
      begin
        @workout_group = WorkoutGroup.find(params[:id])
        @workout_group.update!(workout_group_params)

        flash[:notice] = "Workout Group #{@workout_group.name} was successfully updated."
        redirect_to edit_workout_path(@workout_group.workout.id)

      rescue ActiveRecord::RecordInvalid => error
        flash[:alert] = "There was an error when updating exercise: #{error}"
        render :edit
      end
    end
  end

  def destroy
    @workout = WorkoutGroup.find(params[:id])

    WorkoutGroup.transaction do 
      @workout.workout_group_pairings.each(&:destroy!)
 
      if @workout.delete
        flash[:notice] = 'Workout Group was successfully deleted.'
        redirect_to gym_path(params[:gym_id])
      else
        flash[:alert] = "There was an error when deleting workout group. #{@workout.errors}"
      end
    end
  end

  def workout_groups_by_workout
    @workout = Workout.find(params[:id])

    @workout_groups = @workout.workout_groups

    respond_to do |format|
      format.js { render :json => {workout_groups: @workout_groups} }
    end
  end

  protected

  def workout_group_params
    params.require(:workout_group).permit(:name, :workout_id, :ab_workout)
  end
end
