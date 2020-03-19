class MessageGroupController < ApplicationController
	layout 'nav'
  def show
    @message_group = MessageGroup.find(params[:id])
    @messages = @message_group.messages
    @messages.each do |message|
      message.update(read: true) if message.recipient_id == current_user.id || message.recipient_id.nil?
    end
    @user = current_user
  end
end
