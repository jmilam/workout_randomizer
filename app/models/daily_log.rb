class DailyLog < ApplicationRecord
  belongs_to :user
  has_many :daily_log_foods
  has_many :foods, through: :daily_log_foods

  def total_calories
    daily_log_foods.map { |food_details| food_details.food.calories * food_details.qty }.sum
  end
end
