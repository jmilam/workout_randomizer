class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_gym
  protect_from_forgery with: :null_session

  def set_gym
    @gym = current_user&.gym
  end
end
