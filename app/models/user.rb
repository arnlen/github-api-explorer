# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  stars      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :username, :stars, presence: true
  validates :username, uniqueness: true

  has_many :repositories
end
