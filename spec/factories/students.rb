# == Schema Information
#
# Table name: students
#
#  id              :integer          not null, primary key
#  major           :string
#  graduation_date :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin           :boolean          default("false")
#

FactoryGirl.define do
  factory :student do
    major "MyString"
graduation_date 1
  end

end
