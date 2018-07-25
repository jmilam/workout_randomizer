class Inbox < ApplicationRecord
  belongs_to :user
  has_many :message_groups
end
