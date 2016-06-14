# == Schema Information
#
# Table name: repositories
#
#  id            :integer          not null, primary key
#  name          :string
#  creation_date :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Repository < ApplicationRecord
  validates :name, :creation_date, presence: true
end
