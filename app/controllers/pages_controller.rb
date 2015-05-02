class PagesController < ApplicationController
  def landing
    if user_signed_in? && current_user.teacher?
      redirect_to students_path
    elsif user_signed_in? && current_user.student?
      redirect_to current_user.userable
    else
      redirect_to new_user_session_path
    end
  end
end
