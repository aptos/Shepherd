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

  describe "message" do
    it "returns decoded message" do
      get :message, { id: '13db6d6dcc831885' }
      resp = JSON response.body
      resp['headers'].should_not be_empty
      resp['body'].should_not be_empty
    end

    it "returns decoded message by checking mime types" do
      get :message, { id: '1498760c93aec913' }
      resp = JSON response.body
      resp['headers'].should_not be_empty
      resp['body'].should_not be_empty
    end
  end

end