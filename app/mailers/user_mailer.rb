class UserMailer < ApplicationMailer
	def welcome_email
    @user = params[:user]
    attachments['Nutrition Plan.docx'] = File.read('lib/Nutrition Plan.docx')
    mail(to: @user.email, bcc: ENV['EMAIL'], subject: 'Welcome to Boomslang Fitness!')
  end

  def more_info_email
    @user = params[:user]

    mail(to: ENV['EMAIL'], subject: 'Requesting More Info')
  end
end
