class TeachersController < ApplicationController
  load_and_authorize_resource

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to root_path, notice: "Please confirm your email before loging in"
    else
      render :new
    end
  end

  private

  def teacher_params
    params.require(:teacher).permit(:name, :email, :uid, :password, :password_confirmation, :confirmed_at)
  end
end
