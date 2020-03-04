class CommonExercise < ApplicationRecord
  has_many :exercises
  belongs_to :gym
  accepts_nested_attributes_for :exercises
  validates :name, presence: true, uniqueness: true
end
