class AdminPortalController < ApplicationController
	layout 'nav'
  def index
  	@new_users = User.new_users
  	@new_gyms = Gym.new_gyms
  end

  def report_data
  	date_range = case params[:date_range]
						  	 when 'Month'
						  	    Date.today.beginning_of_month..Date.today.end_of_month
						  	  when 'Year'
						  		  Date.today.beginning_of_year..Date.today.end_of_year
						  	  else
						  		  Date.today.beginning_of_week..Date.today.end_of_week
						  	  end
  		
  	@new_users = User.new_users(date_range)
  	@new_gyms = Gym.new_gyms(date_range)
  	render json: { users: @new_users, gyms: @new_gyms, goals: User.goals }
  end
end
