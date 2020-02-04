class TaskController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:check_if_select_client]
  def new
    @task = Task.new
  end

	def create
    @gym = current_user.gym
    @task = @gym.tasks.new(task_params)

    begin
      @task.save!
      flash[:notice] = "Task #{@task.name} was successfully created."
      redirect_to gym_path @gym.id
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating your task: #{error}"
      redirect_to gym_path @gym.id
    end
	end

  def destroy
    @task = Task.find(params[:id])
    @gym = current_user.gym

    @task.destroy!
    
    flash[:notice] = "Task #{@task.name} was successfully deleted."
    redirect_to gym_path @gym.id
  end

  def check_if_select_client
    task = Task.find(params[:id])
    
    respond_to do |format|
      format.json  { render json: { select_client: task.select_client} }
    end
  end 

  protected

  def task_params
    params.require(:task).permit(:name, :duration, :select_client)
  end                       
end