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

end
