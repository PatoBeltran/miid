# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  code        :string
#  selectable  :boolean          default("true")
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Course < ActiveRecord::Base
  has_many :students, through: :student_courses
  has_many :student_courses
  has_many :requirements, through: :course_requirements
  has_many :course_requirements
  belongs_to :category

  validates :name, :code, :selectable, presence: true

  def to_builder
    Jbuilder.new do |course|
      course.id id
      course.name name
      course.color category.color
    end
  end

  def self.search(q)
    where("name ILIKE (?) or code ILIKE (?) and selectable = 'true'", "%#{q}%", "%#{q}%").limit(20).map{|c| {id: c.id, code: c.code, name: c.name, requirements: c.requirements.count, category: c.category.name, color: c.category.color }}
  end

  def self.get_all(n = 20)
    where(selectable: true).limit(n).map{ |a| { id: a.id, code: a.code, name: a.name, requirements: a.requirements.count, category: a.category.name, color: a.category.color }}
  end
end
