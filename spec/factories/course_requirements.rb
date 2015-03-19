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

FactoryGirl.define do
  factory :course_requirement do
    course_id 1
requirement_id 1
  end

end
