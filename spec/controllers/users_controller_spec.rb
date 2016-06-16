require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user, username: 'arnlen') }
    before { get :index }
    it do
      expect(response).to have_http_status(:success)
      expect(assigns(:users)).to eq([user_2, user_1])
      expect(assigns(:users).first).to be_decorated_with(UserDecorator)
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }

    context "when user doesn't have any repository" do
      before { get :show, params: { username: user.username } }
      it { expect(assigns(:repositories)).to eq([]) }
    end

    context "when user has at least one repository" do
      let(:repository_1) { create(:repository) }
      let(:repository_2) { create(:repository, creation_date: Date.yesterday) }

      before do
        user.repositories << repository_1
        user.repositories << repository_2
        get :show, params: { username: user.username }
      end

      it do
        expect(response).to have_http_status(:success)
        expect(assigns(:user)).to eq(user)
        expect(assigns(:repositories)).to eq([repository_2, repository_1])
      end
    end
  end

  describe "POST #create", :vcr do
    context "when GitHub user doens't exist" do
      before { post :create, params: { username: 'azertyuiopoiuytreza' } }
      it "redirects to home page" do
        expect(response).to redirect_to(controller: 'static_pages', action: "home")
      end
    end

    context "when GitHub user exists" do
      let(:username) { 'arnlen' }
      before { post :create, params: { username: username } }
      it do
        expect(response).to have_http_status(:success)
        expect(assigns(:user).username).to eq(username)
        expect(assert_template('users/show'))
      end
    end
  end

end
