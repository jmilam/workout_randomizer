class GoalController < ApplicationController
	layout 'nav'
  def index
  	@user = current_user

  	@goals = @user.goals
  end

  def create
  	begin
	  	@goal = current_user.goals.new(goal_params)
	  	@goal.save!

      flash[:notice] = "Goal successfully created!"
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating a goal: #{error}"
    ensure
      redirect_to goal_path
    end
  end

  def destroy
  	@goal = Goal.find(params[:id])

  	if @goal.delete
  		flash[:notice] = "Goal successfully deleted"
  	else
  		flash[:alert] = "There was an error when deleting your goal: #{@goal.errors}"
  	end
  	redirect_to goal_path
  end

  private

  def goal_params
    params.require(:goal).permit(:comment)
  end
end
