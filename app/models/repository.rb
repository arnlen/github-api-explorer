# == Schema Information
#
# Table name: repositories
#
#  id            :integer          not null, primary key
#  name          :string
#  creation_date :date
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stars         :integer
#

class Repository < ApplicationRecord
  validates :name, :creation_date, :stars, presence: true
end
