class CommonExerciseController < ApplicationController
  layout 'nav'
  def edit
    @common_exercise = CommonExercise.find(params[:id])
  end

  def create
    gym = current_user.gym
    exercise = gym.common_exercises.create(exercise_params)

    if exercise.save
      flash[:notice] = "Exercise #{exercise.name} was successfully created."
      redirect_to gym_path(gym.id)
    else
      flash[:alert] = "There was an error when creating your exercise: #{exercise.errors.messages}"
      redirect_to gym_path(gym.id)
    end
  end

  def update
    gym = current_user.gym
    @exercise = CommonExercise.find(params[:common_exercise][:id])

    if @exercise.update!(update_exercise_params)
      flash[:notice] = "Exercise #{@exercise.name} was successfully updated."
      redirect_to gym_path(gym.id)
    else
      flash[:alert] = "There was an error when creating your exercise: #{@exercise.errors.messages}"
      redirect_to gym_path(gym.id)
    end
  end

  protected

  def exercise_params
    params.require(:common_exercises).permit(:name, :video)
  end

  def update_exercise_params
    params.require(:common_exercise).permit(:name, :video)
  end
end
