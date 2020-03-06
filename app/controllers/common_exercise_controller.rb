class CommonExerciseController < ApplicationController
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

  protected

  def exercise_params
    params.require(:common_exercises).permit(:name)
  end
end
