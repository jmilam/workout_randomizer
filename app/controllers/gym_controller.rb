class GymController < ApplicationController
  layout 'nav'
  def show
    @non_admins = []
    @admins = []
    @gym = Gym.find(params[:id])

    @gym_users = @gym.users

    @gym.admin_ids.split(',').each do |admin_id|
      user = User.find(admin_id)
      @admins << [user.username, user.id]
    end

    @gym.non_selected_users.each do |user_id|
      user = User.find(user_id)
      @non_admins << [user.username, user.id]
    end

    kiosk_exercise_ids = @gym.kiosks.map(&:exercise_id)

    @exercises = @gym.exercises.map { |exercise| [exercise.name, exercise.id] unless kiosk_exercise_ids.include?(exercise.id) }
                     .delete_if(&:nil?)
  end

  def update
    @gym = Gym.find(params[:id])

    if @gym.update!(gym_params)
      @gym.admin_ids = params[:gym][:admin_ids].delete_if(&:blank?).join(',')
      @gym.save!

      flash[:notice] = 'Successfully Updated Gym Information.'
      redirect_to gym_path(@gym.id)
    end
  end

  protected

  def gym_params
    params.require(:gym).permit(:name, :phone_number, :address, :city, :state, :zipcode)
  end
end
