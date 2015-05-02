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

  validates :uid, format: { with: /(A|a)0[\d]{7}/, message: "only allows students with valid matricula number" }
  validates :email, format: { with: /a0[\d]{7}@itesm.mx/, message: "only allows itesm email accounts" }

  def admin?
    false
  end
end
