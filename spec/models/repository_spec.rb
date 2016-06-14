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

require 'rails_helper'

RSpec.describe Repository, type: :model do
  subject { build(:repository) }

  describe 'validations' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:creation_date) }
  end
end
