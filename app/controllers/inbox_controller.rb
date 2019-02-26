class InboxController < ApplicationController
  layout 'nav'

  def index
    inboxes = current_user.trainer ? User.all.where(trainer_id: current_user.id).map(&:inbox) : [current_user.inbox]

    @message_groups = []

    inboxes.each do |inbox|
    	@message_groups << inbox.message_groups.includes(:messages)
    end
  end
end
