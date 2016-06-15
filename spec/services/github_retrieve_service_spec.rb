require 'rails_helper'

RSpec.describe GithubRetrieveService do
  subject { described_class.new(username) }

  describe "#retrieve_user" do

    context "when the GitHub user doesn't exist" do
      let(:username) { "thebadguy" }
      before { allow(Octokit).to receive(:user).and_raise(Octokit::NotFound) }
      it { expect { subject.retrieve_user }.to raise_error(Octokit::NotFound) }
    end

    context "when the GitHub user exists" do
      let(:user) { build_stubbed(:user) }
      let(:username) { user.username }
      let(:resource) { double login: username, public_repos: 2, followers: 636 }
      let(:repos_array) {[
        { name: "octokit", stargazers_count: 1, created_at: '2012-08-09 09:45:59 UTC' },
        { name: "factory_girl", stargazers_count: 0, created_at: '2015-08-22 17:16:53 UTC' }
      ]}
      let(:repo_1_params) {{
        name: repos_array[0][:name],
        creation_date: Date.parse(repos_array[0][:created_at]),
        stars: repos_array[0][:stargazers_count],
        user_id: user.id
      }}
      let(:repo_2_params) {{
        name: repos_array[1][:name],
        creation_date: Date.parse(repos_array[1][:created_at]),
        stars: repos_array[1][:stargazers_count],
        user_id: user.id
      }}
      let(:relation) {{ repos: double }}

      before do
        allow(Octokit).to receive(:user).and_return(resource)
        allow(resource).to receive(:rels).and_return(relation)
        allow(relation[:repos]).to receive_message_chain(:get, :data).and_return(repos_array)
      end

      context "and the user doesn't exists in our DB" do
        let(:user_params) {{ username: resource.login, followers: resource.followers }}

        before do
          allow(User).to receive(:find_by).and_return(nil)
          allow(User).to receive(:create).and_return(user)
          allow(Repository).to receive(:create)
          @result = subject.retrieve_user
        end

        it { expect(User).to have_received(:create).with(user_params) }
        it { expect(Repository).to have_received(:create).with(repo_1_params) }
        it { expect(Repository).to have_received(:create).with(repo_2_params) }
        it { expect(@result).to eq(user) }
      end

      context "and the user exists in our DB" do
        let(:service) { double synchronize_user: user }

        before do
          allow(User).to receive(:find_by).and_return(user)
          allow(GithubSyncService).to receive(:new).and_return(service)
          @result = subject.retrieve_user
        end

        it { expect(service).to have_received(:synchronize_user) }
        it { expect(@result).to eq(user) }
      end
    end
  end
end
