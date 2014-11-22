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
    Lead.by_uid.map{|r| leads[r[:uid]] = r.to_hash.slice('site','segment','info')}

    # add stats
    stats = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
    site.users.stats.reduce.group_level(2).rows.map{|r| stats[r['key'][0]][r['key'][1]] = r['value'] }

    # merge in values
    @users.map do |u|
      u[:lead] = leads.delete u['id'] # remove found leads from hash
      u[:stats] = stats[u['id']]
    end

    # add in leads who are not yet in users
    leads.keys.each do |uid|
      next unless leads[uid]['site']
      user = { id: uid, name: leads[uid]['info']['name'], visits: 0, info: leads[uid]['info'] } rescue nil
      if user.nil?
      else
        @users.push(user)
      end
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

end