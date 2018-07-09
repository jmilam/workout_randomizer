class InboxController < ApplicationController
	layout 'nav'

	def index
		@user = current_user

		@inbox = current_user.inbox
		@message_groups = @inbox.message_groups.includes(:messages)
	end

end
