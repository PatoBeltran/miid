# == Schema Information
#
# Table name: course_requirements
#
#  id             :integer          not null, primary key
#  course_id      :integer
#  requirement_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CourseRequirement < ActiveRecord::Base
  belongs_to :course
  belongs_to :requirement, class_name: "Course"
end
