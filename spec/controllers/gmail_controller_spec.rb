require 'spec_helper'

describe GmailController, :type => :controller do

  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    controller.stub(:authenticate_admin!).and_return(true)

    admin = FactoryGirl.create(:admin)
    controller.stub(:current_user).and_return(admin)
  end

  describe "inbox" do
    it "returns messages" do
      get :inbox
      (JSON response.body).count.should > 0
    end
  end

  describe "inbox with query" do
    it "returns messages from the query" do
      get :inbox, { q: 'james@taskit.io' }
      (JSON response.body).count.should > 0
    end
  end

end
