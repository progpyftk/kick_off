require "rails_helper"
require_relative "../support/devise"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET /" do
    login_user

    context "from login user" do
      it "should return 200:OK" do
        get :home
        expect(response).to have_http_status(:success)
      end
    end
  end
end