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

FactoryGirl.define do
  factory :student_course do
    student_id 1
course_id 1
  end

end
