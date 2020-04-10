class MessageGroup < ApplicationRecord
  belongs_to :inbox
  has_many :messages

  validates :subject, presence: true
end
