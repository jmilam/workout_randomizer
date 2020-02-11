class TimeCardController < ApplicationController
  layout 'time_card'
  skip_before_action :authenticate_user!
  def new
    # sub_domain = request.domain.scan(/\w+/)[0]
    @gym = Gym.find_by(subdomain: params[:gym])
    @employees = @gym.users.where(employee: true).order(last_name: :asc)
    @clients = @gym.users.where(employee: false).order(last_name: :asc)
    @time_card = TimeCard.new
  end

  def create
    @user = User.find(params[:time_card][:user_id])
    @task = Task.find(params[:time_card][:task_id])
    @client_id = User.find(params[:time_card][:client_id]).id unless params[:time_card][:client_id].empty?

    TimeCard.transaction do
      case params[:manual_entry]
      when "true"
        @time_card = @user.time_cards.new(task_id: @task.id,
                                           client_id: @client_id,
                                           start_time: "#{params[:date]} 12:00".to_datetime.in_time_zone,
                                           end_time: "#{params[:date]} 12:00".to_datetime.in_time_zone + params[:time_card][:duration].to_i.minutes,
                                           manual_entry: true)
        
        @time_card.save!
        flash[:notice] = "Time successfully saved"
        redirect_to gym_path(@user.gym.id)
      else
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
        redirect_to new_time_card_path(gym: @user.gym.subdomain)
      end
    rescue => error
      p @time_card
      p @time_card.errors
      flash[:alert] = "There was an error when inputing your time card #{error}"

      if params[:manual_entry]
        redirect_to gym_path(@user.gym.id)
      else
        redirect_to new_time_card_path(gym: @user.gym.subdomain)
      end
    end
  end
end
