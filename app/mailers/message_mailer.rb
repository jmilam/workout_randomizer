class MessageMailer < ApplicationMailer
	def new_message
    @sender = params[:sender]
    @recipient = params[:recipient]
    @message_group_id = params[:message_group_id]
    mail(to: @recipient.email, from: @sender.email, subject: "You have a new message from #{@sender.first_name} #{@sender.last_name}")
  end
end
