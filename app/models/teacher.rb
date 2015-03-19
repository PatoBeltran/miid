# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  admin      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teacher < ActiveRecord::Base
  acts_as_user
end
