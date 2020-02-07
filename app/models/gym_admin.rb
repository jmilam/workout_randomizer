class GymAdmin < ApplicationRecord
  belongs_to :gym
  validates :gym_id, :user_id, presence: true
end
