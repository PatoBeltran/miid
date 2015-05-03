class StudentsController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:show_tree]

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to root_path, notice: "Please confirm your email before loging in"
    else
      render :new
    end
  end

  def index
    @students = User.where("userable_type = ? and confirmed_at is not NULL", "Student").map(&:userable)
  end

  def show
    Course.eager_load(:course_requirements)
    Course.eager_load(:requirements)

    @student = Student.find(params[:id])
    @courses = Course.get_all
  end

  def show_tree
    Student.eager_load(:courses)
    Course.eager_load(:course_requirements)
    respond_to do |format|
      format.json { render :json => { courses: get_courses(current_user.userable.courses), links: get_links(current_user.userable.courses) } }
    end
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :uid, :password, :password_confirmation, :major, :graduation_date, :confirmed_at)
  end

  def get_links(courses)
    links = []
    courses.map{ |c| c.course_requirements.map{|r| links << r.to_builder.target! }}
    links
  end

  def get_courses(crs)
    courses = []
    crs.map{ |c| courses << c.to_builder.target! }
    crs.map{ |c| c.requirements.map{ |r| courses << r.to_builder.target! unless courses.include? r.to_builder.target! }}
    courses
  end
end
