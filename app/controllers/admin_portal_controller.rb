class AdminPortalController < ApplicationController
	layout 'nav'
  def new_users
  	@new_users = User.new_users
  	@new_gyms = Gym.new_gyms
  end

  def time_cards
    @gym = current_user.gym
    @time_cards = TimeCard.includes(:task).where(user_id: @gym.users.where(trainer: true).map(&:id),
                                 start_time: [Date.today.beginning_of_month..Date.today.end_of_month])
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

  def update_users
    date_range = case params[:date_range]
                 when 'Last Week'
                   Date.today.last_week.beginning_of_week..Date.today.last_week.end_of_week
                 when 'Month'
                    Date.today.beginning_of_month..Date.today.end_of_month
                  when 'Year'
                    Date.today.beginning_of_year..Date.today.end_of_year
                  else
                    Date.today.beginning_of_week..Date.today.end_of_week
                  end
    @gym = current_user.gym
    @time_cards = TimeCard.includes(:task).where(user_id: @gym.users.where(trainer: true).map(&:id),
                                 start_time: date_range)
  end
end
