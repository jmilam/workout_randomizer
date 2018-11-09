class AdminPortalController < ApplicationController
	layout 'nav'
  def index
  	@new_users = User.new_users
  	@new_gyms = Gym.new_gyms
  end
end
