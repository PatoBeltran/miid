# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  admin      :boolean          default("false")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teacher < ActiveRecord::Base
  acts_as_user

  validates :uid, format: { with: /(L|l)0[\d]{7}/, message: "only allows teachers with valid Nómina number" }
  validates :email, format: { with: /([\w+\-].?)+@itesm.mx/, message: "only allows itesm email accounts" }
end
