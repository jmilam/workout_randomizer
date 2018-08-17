class CategoryController < ApplicationController
  layout 'nav'
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    begin
      @category.save!

      flash[:notice] = "Category #{@category.name} was successfully created."
      redirect_to category_index_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating your category: #{error}"
      render :new
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

  protected

  def category_params
    params.require(:category).permit(:name, :tag, :goal_id)
  end
end
