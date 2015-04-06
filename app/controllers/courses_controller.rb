class CoursesController < ApplicationController
  load_and_authorize_resource

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def index
    @courses = Course.all
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :code,  :selectable, :category_id)
  end
end
