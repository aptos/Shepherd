class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @users = site.users.summary.rows.map{|r| r['value']}

    # add in values from settings
    settings = Hash.new
    site.settings.summary.rows.map{|r| settings[r['key']] = r['value'] }
    @users.map do |s|
      next unless settings[s['id']]
      ['email','role', 'entity', 'latLong','email_notifications'].map { |v| s[v] = settings[s['id']][v] if settings[s['id']][v] }
    end

    render :json => @users
  end

  def show
    user = site.users.find(params[:id])
    user['last_visit'] = user.updated_at
    settings = site.settings.by_uid.key(params[:id]).first
    user.merge! settings

    Rails.logger.info "user: #{JSON.pretty_generate user}"

    render :json => user
  end

  def stats
    stats = site.tasks.by_owner_and_status.reduce.rows

    render :json => stats
  end

end