class Food < ApplicationRecord
  has_many :daily_log_foods
  validates :name, :calories, presence: true
  # validates :name, uniqueness: true
  validates :calories, :protein, :carbs, :fat, numericality: true
end
