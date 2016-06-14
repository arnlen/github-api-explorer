require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home as root" do
    before { get :home }
    it { expect(response).to have_http_status(:success) }
  end

end
