class PagesController < ApplicationController

  def home
    if current_user
      @user = {
        email: current_user.email,
        name: current_user.name
      }.to_json
    end
  end

  def index
    home
  end

end
