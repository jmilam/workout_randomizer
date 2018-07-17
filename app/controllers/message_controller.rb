class MessageController < ApplicationController
	def new
		@message_group = if params[:message_group_id].nil?
										 	MessageGroup.new
										 else
										 	 MessageGroup.find(params[:message_group_id])
										 end
		@message = @message_group.messages.new(user_id: current_user.id)
	end

	def create
		ActiveRecord::Base.transaction do
			@message_group = if params[:message][:message_group_id].empty?
											   current_user.inbox.message_groups.create!(subject: params[:subject])
											 else
											 	 MessageGroup.find(params[:message][:message_group_id])
											 end
			@message = @message_group.messages.new(message_params)

			if @message.save!
				redirect_to message_group_path(@message_group.id)
			else
				render :new
			end
		end
	end

	def show
		@message = Message.find(params[:id])
	end

	protected

	def message_params
		params.require(:message).permit(:detail, :user_id)
	end
end