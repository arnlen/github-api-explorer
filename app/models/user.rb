# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  followers  :integer
#

class User < ApplicationRecord
  validates :username, :followers, presence: true
  validates :username, uniqueness: true

  has_many :repositories
end
