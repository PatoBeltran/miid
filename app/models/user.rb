# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  uid                    :string
#  created_at             :datetime
#  updated_at             :datetime
#  userable_type          :string
#  userable_id            :integer
#

class User < ActiveRecord::Base
  is_user
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :uid, presence: true
end
