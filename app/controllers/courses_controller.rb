class CoursesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:link_course, :codes, :unlink_course, :search_courses, :course_description]

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

    respond_to do |format|
      format.json { render :json => { courses: get_courses(current_user.userable.courses), links: get_links(current_user.userable.courses) } }
    end
  end

  def unlink_course
    StudentCourse.where(course_id: params[:course_id], student_id: current_user.userable_id).first.destroy

    respond_to do |format|
      format.json { render :json => {  courses: get_courses(current_user.userable.courses), links: get_links(current_user.userable.courses) } }
    end
  end

  def codes
    respond_to do |format|
      format.json { render :json => Course.where("code ILIKE (?)", "%#{params[:q]}%").pluck(:code) }
    end
  end

  def search_courses
    respond_to do |format|
      format.json { render :json => Course.search(params[:q]) }
    end
  end

  def course_description
    course = Course.find(params[:course_id])
    respond_to do |format|
      format.json { render :json => { name: course.name , text: course.description }}
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

  def get_courses(crs)
    courses = []
    crs.map{ |c| courses << c.to_builder.target! }
    crs.map{ |c| c.requirements.map{ |r| courses << r.to_builder.target! unless courses.include? r.to_builder.target!  }}
    courses
  end

  def create_requirements(course, requirements)
    requirements.split(",").each do |code|
      req = Course.find_by(code: code)
      course.requirements << req if req.present?
    end
  end
end
