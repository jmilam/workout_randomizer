class MealController < ApplicationController
  layout :choose_layout

  def choose_layout
    if current_user.nutrition_only
      "nutrition"
    else
      "application"
    end
  end

  def index
    @user = current_user
    @food_groups = @user.gym.food_groups
  end
end