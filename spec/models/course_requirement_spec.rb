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

require 'rails_helper'

RSpec.describe CourseRequirement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
