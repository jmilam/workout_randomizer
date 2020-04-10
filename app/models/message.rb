class Message < ApplicationRecord
  belongs_to :message_group
  belongs_to :user

  validates :detail, :recipient_id, presence: true
  def user_name
    "#{user.first_name} #{user.last_name}"
  end
end
