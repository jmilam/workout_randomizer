class MessageGroup < ApplicationRecord
  belongs_to :inbox
  has_many :messages
end
