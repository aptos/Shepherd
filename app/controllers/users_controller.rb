class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    render :json => User.by_email.all
  end

  def show
    user = User.find(params[:id])
    render :json => user
  end

  def team
    if !current_user.company || (current_user.company[:name] == "Independent Contractor")
      @team = []
    else
      @team = User.by_company.key(current_user.company['id']).values
      unless params[:inclusive]
        @team = @team - [{"id" => current_user.uid, "text" => current_user.name}]
      end
    end
    render :json => @team
  end

  def skills
    @skills = User.skills_and_certifications.reduce.group_level(1).rows
    render :json => @skills
  end

end