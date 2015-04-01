class PagesController < ApplicationController
  def landing
    if user_signed_in? && current_user.teacher?
      redirect_to students_path
    elsif user_signed_in? && current_user.student?
      redirect_to current_user.userable
    end
  end
end
