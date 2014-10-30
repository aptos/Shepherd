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
    
    # add lead
    leads = Hash.new
    Lead.by_uid.map{|r| leads[r[:uid]] = r.to_hash.slice('segment','last_contacted')}
    @users.map{|u| u[:lead] = leads[u['id']]}

    render :json => @users
  end

  def show
    user = site.users.find(params[:id])
    user['last_visit'] = user.updated_at
    settings = site.settings.by_uid.key(params[:id]).first
    user.merge! settings

    render :json => user
  end

  def stats
    stats = site.tasks.by_owner_and_status.reduce.rows

    render :json => stats
  end

end