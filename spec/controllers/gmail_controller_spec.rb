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
      get :inbox, { q: 'bswilkerson@gmail.com' }
      (JSON response.body).count.should > 0
    end
  end

  describe "when other admins contact the user" do
    before do
      @message = FactoryGirl.create(:ahoy_message, { sent_at: Time.now })
    end
    it "returns summary messages from the query" do
      get :inbox, { q: 'bswilkerson@gmail.com' }
      assigns(:list)['messages'].last[:labelIds].should eq ["SENT", "SUMMARY", "UNREAD"]
      assigns(:list)['messages'].last[:subject].should eq @message[:subject]
    end
  end

  describe "get_message" do
    it "returns decoded message" do
      get :message, { id: '13db6d6dcc831885' }
      resp = JSON response.body
      resp['headers'].should_not be_empty
      resp['body'].should_not be_empty
    end

    it "returns decoded message with special chars" do
      get :message, { id: '1498760c93aec913' }
      resp = JSON response.body
      resp['headers'].should_not be_empty
      resp['body'].should_not be_empty
    end
  end

  describe "send_message" do
    before do
      @message = {
        subject: 'testing 1,2,3',
        body: "Text message body\n<a href='https://www.taskit.io'>TaskIT.io</a>"
      }
    end

    it "sends a message" do
      post :send_message, { uid:'bswilkerson@gmail.com', gmail: {new_message: @message}}
      resp = JSON response.body
      resp['id'].should_not be_nil
    end

    it "adds tracking to links" do
      post :send_message, { uid:'bswilkerson@gmail.com', gmail: {new_message: @message}}
      assigns(:payload).body.should match 'utm_campaign%3Dintroducing_taskit'
    end

    it "tracks template as utm_content" do
      post :send_message, { uid:'bswilkerson@gmail.com', gmail: {new_message: @message, 'template' => 'Welcome to TaskIT!'}}
      assigns(:payload).body.should match 'utm_content%3Dwelcome_to_taskit_'
    end
  end

end