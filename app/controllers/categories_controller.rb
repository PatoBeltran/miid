class CategoriesController < ApplicationController
  load_and_authorize_resource

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def index
    @categories = Category.all
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to categories_path, notice: "Categoria Borrada"
  end

  private

  def category_params
    params.require(:category).permit(:name, :color)
  end
end
