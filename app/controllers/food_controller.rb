class FoodController < ApplicationController
  layout :choose_layout

  def choose_layout
    if current_user.nutrition_only
      "nutrition"
    else
      "application"
    end
  end

  def index
    @gym = current_user.gym
    @foods = Food.where(created_by_user_id: current_user.id).group_by(&:category)
    @food_categories = Category.food_categories
  end

  def new
    @gym = current_user.gym
    @food = Food.new
  end

  def edit
    flash[:notice] = nil
    flash[:alert] = nil
    @gym = current_user.gym
    @food = Food.find(params[:id])
  end

  def create
    @food = Food.new(food_params)

    begin
      @food.save!

      flash[:notice] = "Food successfully created!"
      redirect_to food_index_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = error
      redirect_to new_food_path
    end
  end

  def update
    @food = Food.find(params[:id])

    begin
      @food.update(food_params)

      flash[:notice] = "Food successfully updated!"
      redirect_to food_index_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = error
      redirect_to edit_food_path(@food.id)
    end
  end

  def find_food_by_category
    @foods = Food.where(category: params[:category])

    respond_to do |format|
      format.js
    end
  end

  protected

  def food_params
    params.require(:food).permit(:created_by_user_id, :name, :calories, :category, :name, :protein, :carbs, :fat, :serving_size)
  end
end
