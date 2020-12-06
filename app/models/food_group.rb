class FoodGroup < ApplicationRecord
  has_many :food_group_pairings, dependent: :destroy
  belongs_to :user
  validates :name, :gym_id, presence: true
end
