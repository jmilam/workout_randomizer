class MessageGroupController < ApplicationController
	layout 'nav'
  def show
    @message_group = MessageGroup.find(params[:id])
    @messages = @message_group.messages
    @recipient = User.find_by(id: @messages.map { |message| message.user_id }.delete_if { |id| id == current_user.id }.uniq)
    @messages.each do |message|
      message.update(read: true) if message.recipient_id == current_user.id || message.recipient_id.nil?
    end
    @user = current_user
  end
end
