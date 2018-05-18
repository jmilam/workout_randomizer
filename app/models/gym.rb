class Gym < ApplicationRecord
  has_many :users
  has_many :workouts

  validates :name, :phone_number, presence: true
end
