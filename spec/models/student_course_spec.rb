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

require 'rails_helper'

RSpec.describe StudentCourse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
