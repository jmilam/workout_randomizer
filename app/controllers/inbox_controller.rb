class InboxController < ApplicationController
  layout 'nav'

  def index
    inboxes = current_user.trainer ? User.all.where(trainer_id: current_user.id).map(&:inbox) : [current_user.inbox]
    p MessageGroup.last.messages
    @message_groups = Message.includes(:message_group)
                             .where("user_id = ? OR recipient_id = ?", current_user.id, current_user.id)
                             .map(&:message_group)
                             .delete_if(&:nil?)
                             .uniq
  end
end
