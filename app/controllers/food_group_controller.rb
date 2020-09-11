class FoodGroupController < ApplicationController
  layout 'nav'
  def index
    @food_groups = current_user.gym.food_groups
  end

  def new
    @food_group = current_user.gym.food_groups.new
    @grouped_foods = Food.where(created_by_user_id: nil).group_by(&:category)
    @food_totals = @food_group.food_group_pairings.map do |pair|
      { total_calories: 0,
        total_protein: 0,
        total_carbs: 0,
        total_fat: 0
      }
    end
  end

  def edit
    @food_group = FoodGroup.includes(:food_group_pairings).find(params[:id])
    @food_ids = @food_group.food_group_pairings.pluck(:food_id)
    @grouped_foods = Food.where(created_by_user_id: nil).group_by(&:category)

    @food_totals = @food_group.food_group_pairings.map do |pair|
      { total_calories: pair.serving_qty * pair.food.calories,
        total_protein: pair.serving_qty * pair.food.protein,
        total_carbs: pair.serving_qty * pair.food.carbs,
        total_fat: pair.serving_qty * pair.food.fat
      }
    end
  end

  def create
    begin
      @grouped_foods = Food.where(created_by_user_id: nil).group_by(&:category)
      @food_group = current_user.gym.food_groups.new(food_group_params)

      raise "ERROR" if params[:food_group][:food_group_pairings].nil?

      params[:food_group][:food_group_pairings][:food_id].each do |food_id|
        @food_group.food_group_pairings.new(food_id: food_id,
                                            serving_qty:  params[:food_group_food_group_pairings_serving_qty][food_id])
      end

      @food_group.save!

      flash[:notice] = "Food Group #{@food_group.name} was successfully created."
      redirect_to gym_path(curren_user.gym.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating your food group: #{error}"
      render :new
    rescue RuntimeError => error
      flash[:alert] = "There was an error when creating your food group: #{error}"
      render :new
    end
  end

  def update
    begin
      @food_group = FoodGroup.includes(:food_group_pairings).find(params[:id])
      @food_group.name = params[:food_group][:name]

      @grouped_foods = Food.where(created_by_user_id: nil).group_by(&:category)

      raise "ERROR" if params[:food_group][:food_group_pairings].nil?
      raise ActiveRecord::RecordInvalid, @food_group if !@food_group.valid?

      @food_group.food_group_pairings.each do |pairing|
        pairing.destroy!
      end

      params[:food_group][:food_group_pairings][:food_id].each do |food_id|
        @food_group.food_group_pairings.new(food_id: food_id,
                                            serving_qty:  params[:food_group_food_group_pairings_serving_qty][food_id])
      end

      @food_ids = @food_group.food_group_pairings.pluck(:food_id)
      @grouped_foods = Food.where(created_by_user_id: nil).group_by(&:category)
      @food_totals = @food_group.food_group_pairings.map do |pair|
        { total_calories: pair.serving_qty * pair.food.calories,
          total_protein: pair.serving_qty * pair.food.protein,
          total_carbs: pair.serving_qty * pair.food.carbs,
          total_fat: pair.serving_qty * pair.food.fat
        }
      end

      @food_group.save!

      flash[:notice] = "Food Group #{@food_group.name} was successfully updated."
      redirect_to gym_path(current_user.gym.id)
    rescue ActiveRecord::RecordInvalid => error
      @food_ids = @food_group.food_group_pairings.pluck(:food_id)
      @food_totals = @food_group.food_group_pairings.map do |pair|
        { total_calories: pair.serving_qty * pair.food.calories,
          total_protein: pair.serving_qty * pair.food.protein,
          total_carbs: pair.serving_qty * pair.food.carbs,
          total_fat: pair.serving_qty * pair.food.fat
        }
      end

      flash[:alert] = "There was an error when creating your food group: #{error}"
      render :edit
    rescue RuntimeError => error
      @food_ids = @food_group.food_group_pairings.pluck(:food_id)
      @food_totals = @food_group.food_group_pairings.map do |pair|
        { total_calories: pair.serving_qty * pair.food.calories,
          total_protein: pair.serving_qty * pair.food.protein,
          total_carbs: pair.serving_qty * pair.food.carbs,
          total_fat: pair.serving_qty * pair.food.fat
        }
      end

      flash[:alert] = "There was an error when creating your food group: #{error}"
      render :edit
    end
  end

  protected

  def food_group_params
    params.require(:food_group).permit(:name)
  end
end