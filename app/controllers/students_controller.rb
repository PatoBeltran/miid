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
    @student = Student.find(params[:id])
    @courses = Course.all.includes(:requirements, :course_requirements)
  end

  def show_tree
    Student.eager_load(:courses)
    Course.eager_load(:course_requirements)
    respond_to do |format|
      format.json { render :json => { courses: current_user.userable.courses.map{|c| c.to_builder.target! }, links: get_links(current_user.userable.courses) } }
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
end
