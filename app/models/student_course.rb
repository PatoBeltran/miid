# == Schema Information
#
# Table name: student_courses
#
#  id         :integer          not null, primary key
#  student_id :integer
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudentCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :student
end
