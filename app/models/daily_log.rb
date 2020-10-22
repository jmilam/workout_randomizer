class DailyLog < ApplicationRecord
  belongs_to :user
  has_many :daily_log_foods
  has_many :foods, through: :daily_log_foods

  def total_calories
    daily_log_foods.map { |food_details| calculate_by_macro(food_details.food&.calories, food_details.qty) }.sum
  end

  def total_protein
    daily_log_foods.map { |food_detials| calculate_by_macro(food_detials.food&.protein, food_detials.qty) }.sum
  end

  def total_carbs
    daily_log_foods.map { |food_detials| calculate_by_macro(food_detials.food&.carbs, food_detials.qty) }.sum
  end

  def total_fats
    daily_log_foods.map { |food_detials| calculate_by_macro(food_detials.food&.fat, food_detials.qty) }.sum
  end

  def calculate_by_macro(food_macro_count, qty)
    (food_macro_count || 0) * qty
  end
end
