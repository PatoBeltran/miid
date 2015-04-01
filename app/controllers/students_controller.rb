class StudentsController < ApplicationController
  load_and_authorize_resource

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
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :uid, :password, :password_confirmation, :major, :graduation_date, :confirmed_at)
  end
end
