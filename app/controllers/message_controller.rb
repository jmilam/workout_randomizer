class MessageController < ApplicationController
  layout 'nav'
  def new
    @message_group = if params[:message_group_id].nil?
                       MessageGroup.new
                     else
                       MessageGroup.find(params[:message_group_id])
                     end
    @message = @message_group.messages.new(user_id: current_user.id)
    @recipient_id = params[:recipient_id]
    @clients = User.where(trainer_id: current_user.id)
  end

  def create
    ActiveRecord::Base.transaction do
      @message_group = if params[:message][:message_group_id].empty?
                         current_user.inbox.message_groups.new(subject: params[:subject])
                       else
                         MessageGroup.find(params[:message][:message_group_id])
                       end
      @message = @message_group.messages.new(message_params)

      unless params[:message][:trainer_id].blank?
        @message.recipient_id = params[:message][:trainer_id]
      end

      if @message.recipient_id.nil?
        # Look Up last message of message group and pull from there. Client hasn't responded yet
        recipient_id = @message_group.messages.where.not(recipient_id: current_user.id).last&.recipient_id
        @message.recipient_id = recipient_id unless recipient_id.nil?
      end

      
      if @message.save! && @message_group.save!
        # Send email
        recipient_id = params[:message][:trainer_id].presence || params[:message][:recipient_id]
        unless recipient_id.blank?
          recipient = User.find(recipient_id)
          MessageMailer.with(recipient: recipient, sender: User.find(@message.user_id), message_group_id: @message_group.id)
                       .new_message
                       .deliver_now
        end

        redirect_to message_group_path(@message_group.id)
      else
        render :new
      end
    rescue ActiveRecord::RecordInvalid => error
      @clients = User.where(trainer_id: current_user.id)

      flash[:alert] = "There was an error when sending your message: #{error}"
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  protected

  def message_params
    params.require(:message).permit(:detail, :user_id, :recipient_id)
  end
end
