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

    # add stats
    stats = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
    site.users.stats.reduce.group_level(2).rows.map{|r| stats[r['key'][0]][r['key'][1]] = r['value'] }

    # merge in values
    @users.map do |u| 
      u[:lead] = leads[u['id']]
      u[:stats] = stats[u['id']]
    end

    render :json => @users
  end

  def show
    user = site.users.find(params[:id])
    unless user
      render :json => { error: "user not found #{params[:id]}"}, status: 404 and return
    end
    user['last_visit'] = user.updated_at
    settings = site.settings.by_uid.key(params[:id]).first
    user.merge! settings

    render :json => user
  end

  def activity
    key = params[:id]
    @activities = site.users.activity.startkey([key]).endkey([key,{},{},{}]).rows
    @activities = [] unless @activities
    
    render :json => @activities
  end

  def report
    last_week = Date.today - 7
    @recent = Hash.new
    Shepherd::Application.config.sites.each do |s|
      site = Site.by_slug.key("#{s[:db]}_#{Rails.env}").first
      users = site.users.by_created_at.descending().limit(100).rows.keep_if {|u| last_week < Date.parse(u['key']) }
      users.map do |user|
        user[:profile] = site.users.find(user['id'])
      end
      @recent[s[:label]] = users
    end



    respond_to do |format|
      format.html
      format.json{
        render :json => { recent: @recent }
      }
    end
  end

end