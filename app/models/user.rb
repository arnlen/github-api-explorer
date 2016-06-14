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
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:stars) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:repositories) }
  end
end
