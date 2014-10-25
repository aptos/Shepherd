class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @users = site.users.summary.rows.map{|r| r['value']}

    # add in values from settings
    settings = Hash.new
    site.settings.summary.rows.map{|r| settings[r['key']] = r['value'] }
    @users.map do |s|
      ['role', 'entity', 'latLong','email_notifications'].map{|v| s[v] = settings[s['id']][v] if settings[s['id']][v] }
    end

    render :json => @users
  end

  def show
    user = site.users.find(params[:id])
    render :json => user
  end

end