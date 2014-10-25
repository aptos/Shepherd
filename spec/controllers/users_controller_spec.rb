require 'spec_helper'

describe UsersController, :type => :controller do

  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
    controller.stub(:authenticate_user!).and_return(true)

  end

  describe "index" do
    it "returns all users" do
      get :index
      (JSON response.body).count.should > 0
    end
  end

  describe "show" do
    it "shows profile for requested uid" do
      get :show, {id: 'zoevollersen@gmail.com'}
      (JSON response.body)['name'].should_not be_empty
    end
  end

end
