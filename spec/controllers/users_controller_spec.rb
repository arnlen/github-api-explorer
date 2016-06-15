require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    before { get :index }
    it do
      expect(response).to have_http_status(:success)
      expect(assigns(:users)).to eq([user])
      expect(assigns(:users).first).to be_decorated_with(UserDecorator)
    end
  end

  describe "GET #show" do

    context "when user has at a repository" do
      let(:repository) { create(:repository) }

      before do
        user.repositories << repository
        get :show, params: { username: user.username }
      end

      it do
        expect(response).to have_http_status(:success)
        expect(assigns(:user)).to eq(user)
        expect(assigns(:repositories)).to eq([repository])
      end
    end

    context "when user doesn't have any repository" do
      before { get :show, params: { username: user.username } }
      it { expect(assigns(:repositories)).to eq([]) }
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
