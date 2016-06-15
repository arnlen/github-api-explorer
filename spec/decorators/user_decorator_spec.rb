require 'rails_helper'

RSpec.describe UserDecorator do

  describe "#repository_counter" do
    let(:user) { create(:user).decorate }
    let(:repository) { create(:repository) }

    before { user.repositories << repository }

    it { expect(user.repository_counter).to eq(1) }
  end
end
