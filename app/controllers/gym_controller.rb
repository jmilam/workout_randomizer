class GymController < ApplicationController
  layout 'onboarding'
  def new
    @gym = Gym.new
  end

  def show
    @non_admins = []
    @gym = Gym.find(params[:id])

    @gym_users = @gym.users.order(:last_name)

    kiosk_exercise_ids = @gym.kiosks.map(&:exercise_id)

    @exercises = CommonExercise.all.map { |exercise| [exercise.name, exercise.id] unless kiosk_exercise_ids.include?(exercise.id) }
                     .delete_if(&:nil?)

    @popup_workouts = Wod.where(gym_id: @gym.id).order(:workout_date)

    @categories = @gym.categories
    @category = @gym.categories.new
    @tasks = @gym.tasks.order(name: :asc)
    @workouts = current_user.gym.workouts
    @employees = @gym.users.where(employee: true).order(last_name: :asc)
    @clients = @gym.users.where(employee: false).order(last_name: :asc)
  end

  def create
    @gym = Gym.new(params.require(:gym).permit(:name, :phone_number, :address, :city, :state, :zipcode, :time_zone, :logo))
    
    @gym.save

    flash[:notice] = 'Gym created'
    redirect_to gym_path(@gym.id)
  end

  def update
    @gym = Gym.find(params[:id])

    if @gym.update!(gym_params)
      @gym.save!

      flash[:notice] = 'Successfully Updated Gym Information.'
      redirect_to gym_path(@gym.id)
    end
  end

  protected

  def gym_params
    params.require(:gym).permit(:name, :phone_number, :address, :city, :state, :zipcode, :logo)
  end
end
