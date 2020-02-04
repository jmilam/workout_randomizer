class TimeCardController < ApplicationController
  layout 'time_card'
  skip_before_action :authenticate_user!
  def new
    sub_domain = request.domain.scan(/\w+/)[0]
    @gym = Gym.find_by(subdomain: sub_domain)
    @employees = @gym.users.where(trainer: true)
    @clients = @gym.users.where(trainer: false)
    @time_card = TimeCard.new
  end

  def create
    @user = User.find(params[:time_card][:user_id])
    @task = Task.find(params[:time_card][:task_id])
    @client_id = User.find(params[:time_card][:client_id]).id unless params[:time_card][:client_id].empty?

    TimeCard.transaction do
      if params[:sign_in_out].downcase == "clock in"
        time_card = @user.time_cards.new(task_id: @task.id, client_id: @client_id).set_task_specifics(@task)
        time_card.save
      else
        # Do sign out stuff
        @user.time_cards.where(task_id: @task.id, end_time: nil).each do |time_card|
          time_card.end_time = Time.now.in_time_zone
          time_card.save
        end
      end

      flash[:notice] = "Time successfully saved"
      redirect_to new_time_card_path
    rescue => error
      flash[:alert] = "There was an error when inputing your time card #{error}"
      redirect_to new_time_card_path
    end
  end
end
