class FoodGroupPairing < ApplicationRecord
  belongs_to :food_group
  belongs_to :food
  validates :food_id, :serving_qty, presence: true
end
