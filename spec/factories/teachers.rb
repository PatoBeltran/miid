# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  admin      :boolean          default("false")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :teacher do
    admin ""
  end

end
