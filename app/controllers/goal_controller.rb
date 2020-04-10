class GoalController < ApplicationController
	layout 'nav'
  def create
  	begin
	  	@goal = current_user.goals.new(goal_params)
	  	@goal.save!

      flash[:notice] = "Goal successfully created!"
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating a goal: #{error}"
    ensure
      redirect_to edit_profile_path(current_user.id)
    end
  end

  def destroy
  	@goal = Goal.find(params[:id])

  	if @goal.delete
  		flash[:notice] = "Goal successfully deleted"
  	else
  		flash[:alert] = "There was an error when deleting your goal: #{@goal.errors}"
  	end
  	redirect_to edit_profile_path(current_user.id)
  end

  private

  def goal_params
    params.require(:goal).permit(:comment)
  end
end
