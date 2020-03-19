class Inbox < ApplicationRecord
  belongs_to :user
  has_many :message_groups

  validates :user_id, uniqueness: true
end
