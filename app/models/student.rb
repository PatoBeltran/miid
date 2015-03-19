# == Schema Information
#
# Table name: students
#
#  id              :integer          not null, primary key
#  major           :string
#  graduation_date :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Student < ActiveRecord::Base
  acts_as_user
  has_many :courses, through: :student_courses
  has_many :student_courses
end
