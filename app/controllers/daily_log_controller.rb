class DailyLogController < ApplicationController
  layout :choose_layout

  def choose_layout
    if current_user.nutrition_only
      "nutrition"
    else
      "application"
    end
  end

  def index
    @daily_logs = current_user.daily_logs.order(created_at: :desc)
    @today_log = current_user.daily_logs.find_by(calendar_date: Date.today.in_time_zone)
  end

  def edit
    @daily_log = DailyLog.find(params[:id])
    @foods = Food.where(created_by_user_id: current_user.id).group_by(&:category)
    @food_categories = Category.food_categories
  end

  def show
    @daily_log = DailyLog.find(params[:id])
    @daily_log_foods = @daily_log.daily_log_foods.includes(:food).group_by(&:food_id)
  end

  def new
    @daily_log = current_user.daily_logs.find_or_initialize_by(calendar_date: Date.today.in_time_zone)
    @foods = Food.where(created_by_user_id: current_user.id).group_by(&:category)
    @food_categories = Category.food_categories
  end

  def create
    begin
      @daily_log = current_user.daily_logs.new(calendar_date: Date.today.in_time_zone)
      params[:selected_food_ids].split(',').delete_if(&:empty?).each do |food_id|
        @daily_log.daily_log_foods.new(food_id: food_id, qty: 1)
      end

      flash[:notice] = "Successfully logged food."
      @daily_log.save!
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when logging your food: #{error}"
    ensure
      redirect_to daily_log_path(@daily_log.id)
    end
  end

  def update
    begin
      @daily_log = DailyLog.find(params[:id])
      params[:selected_food_ids].split(',').delete_if(&:empty?).each do |food_id|
        @daily_log.daily_log_foods.create!(food_id: food_id, qty: 1)
      end

      flash[:notice] = "Successfully logged food."
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when logging your food: #{error}"
    ensure
      redirect_to daily_log_path(@daily_log.id)
    end
  end

  def destroy_daily_log_food
    @daily_log_food = DailyLogFood.find(params[:id])

    @daily_log_food.destroy!

    flash[:notice] = "Food removed from today's log"
    redirect_to daily_log_path(@daily_log_food.daily_log_id)
  end
 end