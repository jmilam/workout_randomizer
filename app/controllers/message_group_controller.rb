class MessageGroupController < ApplicationController
	def show
		@message_group = MessageGroup.find(params[:id])
		@messages = @message_group.messages
	end
end
