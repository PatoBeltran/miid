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

FactoryGirl.define do
  factory :course do
    name "MyString"
description "MyText"
code "MyString"
selectable false
  end

end
