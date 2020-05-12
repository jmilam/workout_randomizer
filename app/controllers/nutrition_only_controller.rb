class NutritionOnlyController < ApplicationController
  skip_before_action :authenticate_user!
	layout 'nutrition_only'
  def index
    @gyms = Gym.all.includes(:users)
    @gym = Gym.find_by(subdomain: params[:gym])
  end

  def create
    @user = User.new(user_params)
    @user.not_a_robot = true
    @user.nutrition_only = true

    #store values in case error
    @gyms = Gym.all.includes(:users)
    
    if @user.save
      Inbox.create(user_id: @user.id)
      sign_in @user
      flash[:notice] = "Welcome #{@user.username}!"
      redirect_to profile_index_path
    else
      error_string = ""
      @user.errors.messages.each do |key, messages|
        error_string << "#{key}: " + messages.join(',') + "\n"
      end
      flash[:alert] = error_string
      render nutrition_only_index_path
    end
  end

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :password, :email, :tdee, :gym_id)
  end
end
