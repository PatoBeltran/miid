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

require 'rails_helper'

RSpec.describe Student, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
