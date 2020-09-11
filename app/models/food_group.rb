class FoodGroup < ApplicationRecord
  has_many :food_group_pairings
  belongs_to :gym
  validates :name, :gym_id, presence: true
end
