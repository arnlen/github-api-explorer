require 'rails_helper'

RSpec.describe GithubSyncService do
  let(:user) { build_stubbed(:user) }
  subject { described_class.new(user).synchronize_user_with(resource) }

  describe "#synchronize_user_with" do
    let(:resource) { double login: user.username, followers: user.followers }
    let(:repository_1) { build_stubbed(:repository) }
    let(:repository_2) { build_stubbed(:repository) }
    let(:relation) {{ repos: double }}
    let(:repos_array) {[
      { name: repository_1.name, stargazers_count: repository_1.stars, created_at: '2012-08-09 09:45:59 UTC' },
      { name: repository_2.name, stargazers_count: repository_2.stars, created_at: '2012-08-09 09:45:59 UTC' }
    ]}

    before do
      allow(user).to receive(:update_attribute)
      allow(user).to receive(:repositories).and_return([repository_1, repository_2])
      allow(repository_1).to receive(:update_attribute)
      allow(repository_2).to receive(:update_attribute)
      allow(repository_2).to receive(:delete)
      allow(resource).to receive(:rels).and_return(relation)
      allow(relation[:repos]).to receive_message_chain(:get, :data).and_return(repos_array)
    end

    context "when user's data are outdated" do
      let(:resource) { double login: user.username, followers: 60 }
      before { @result = subject }
      it { expect(user).to have_received(:update_attribute) }
      it { expect(@result).to eq(user) }
    end

    context "when user's data are up to date" do
      before { subject }
      it { expect(user).not_to have_received(:update_attribute) }
    end

    context "when an user's repository had been deleted on GitHub" do
      let(:repos_array) {[{ name: repository_1.name, stargazers_count: repository_1.stars, created_at: '2012-08-09 09:45:59 UTC' }]}
      before { subject }
      it { expect(repository_2).to have_received(:delete) }
    end

    context "when user's repositories' data are outdated" do
      let(:repos_array) {[
        { name: repository_1.name, stargazers_count: 1, created_at: '2012-08-09 09:45:59 UTC' },
        { name: repository_2.name, stargazers_count: 2, created_at: '2012-08-09 09:45:59 UTC' }
      ]}
      before { subject }
      it { expect(repository_1).to have_received(:update_attribute) }
      it { expect(repository_2).to have_received(:update_attribute) }
    end

    context "when user's repositories' data are up to date" do
      before { subject }
      it { expect(repository_1).not_to have_received(:update_attribute) }
      it { expect(repository_2).not_to have_received(:update_attribute) }
    end
  end
end
