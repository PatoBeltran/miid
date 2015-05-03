class CoursesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:link_course, :codes, :unlink_course, :search_courses]

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      create_requirements(@course, params[:course_requirements])
      redirect_to courses_path
    else
      render :new
    end
  end

  def index
    @courses = Course.where(selectable: true)
  end

  def link_course
    @course = Course.find(params[:course_id])
    unless current_user.userable.userable.courses.where(id: params[:course_id]).any?
      current_user.userable.courses << @course
    end

    Student.eager_load(:courses)
    Course.eager_load(:course_requirements)
    respond_to do |format|
      format.json { render :json => { courses: current_user.userable.courses.map{|c| c.to_builder.target! }, links: get_links(current_user.userable.courses) } }
    end
  end

  def unlink_course
    StudentCourse.where(course_id: params[:course_id], student_id: current_user.userable_id).destroy
    Student.eager_load(:courses)
    Course.eager_load(:course_requirements)
    respond_to do |format|
      format.json { render :json => { courses: current_user.userable.courses.map{|c| c.to_builder.target! }, links: get_links(current_user.userable.courses) } }
    end
  end

  def codes
    respond_to do |format|
      format.json { render :json => Course.where("code ILIKE (?)", "%#{params[:q]}%").pluck(:code) }
    end
  end

  def search_courses
    respond_to do |format|
      format.json { render :json => Course.search(params[:q]).limit(20) }
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :code,  :selectable, :category_id)
  end

  def get_links(courses)
    links = []
    courses.map{ |c| c.course_requirements.map{|r| links << r.to_builder.target! }}
    links
  end

  def create_requirements(course, requirements)
    requirements.split(",").each do |code|
      req = Course.find_by(code: code)
      course.requirements << req if req.present?
    end
  end
end
