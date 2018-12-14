class UserMailer < ApplicationMailer
	def welcome_email
    @user = params[:user]
    mail(to: @user.email, bcc: ENV['EMAIL'], subject: 'Welcome to Boomslang Fitness!')
  end
end
