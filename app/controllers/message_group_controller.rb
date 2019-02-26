class MessageGroupController < ApplicationController
	layout 'nav'
  def show
    @message_group = MessageGroup.find(params[:id])
    @messages = @message_group.messages
    @user = current_user
  end
end
