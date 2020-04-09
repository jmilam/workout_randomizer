class CategoryController < ApplicationController
  layout 'nav'
  def index
    @categories = Category.all
  end

  def new
    @category = current_user.gym.categories.new
  end

  def create
    @gym = current_user.gym
    @category = @gym.categories.new(category_params)

    begin
      @category.save!
      @category.update!(created_by_user_id: current_user.id)
      flash[:notice] = "Category #{@category.name} was successfully created."
      redirect_to gym_path @gym.id
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating your category: #{error}"
      redirect_to gym_path @gym.id
    end
  end

  def edit
    @category = Category.find(params[:id])
    @category_backgrounds = Category.style_tags.values.map { |val| val["background-color"] }
  end

  def update
    @category = Category.find(params[:id])

    begin
      @category.update(category_params)

      flash[:notice] = "Category #{@category.name} was successfully updated."
      redirect_to category_index_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating your category: #{error}"
      render :edit, id: @category.id
    end
  end

  def disable_category
    begin
      category = Category.find(params[:id])
      category.update!(disabled: true)
      flash[:notice] = "Category was disabled successfully."
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when disabling your category: #{error}"
    ensure
      redirect_to gym_path category.gym_id
    end
  end

  def enable_category
    begin
      category = Category.find(params[:id])
      category.update!(disabled: false)
      flash[:notice] = "Category was enabled successfully."
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when enabling your category: #{error}"
    ensure
      redirect_to gym_path category.gym_id
    end
  end

  protected

  def category_params
    params.require(:category).permit(:name, :tag, :goal_id)
  end
end
