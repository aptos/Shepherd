class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @users = site.users.summary.rows.map{|r| r['value']}

    # add lead
    leads = Hash.new
    Lead.by_site.key(site_name).map{|r| leads[r[:uid]] = r.to_hash.slice('segment','info')}

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
      next unless leads[uid]['info']
      logger.info "Segment: #{uid} - #{leads[uid]['segment']}"
      company = leads[uid]['info']['company'] rescue ''
      user = { id: uid, name: leads[uid]['info']['name'], visits: 0, company: { name: company }, lead: { segment: leads[uid]['segment'], info: leads[uid]['info'] }} rescue nil
      if user.nil?
      else
        @users.push(user)
      end
    end

    render :json => @users
  end

  def providers
    @users = site.users.summary.rows.map{|r| r['value']}

    settings = site.settings.by_uid.all
    keyed_view = Hash.new
    settings.map{|r| keyed_view[r['uid']] = r}

    @users.delete_if{|u| !keyed_view[u['id']]['roles'].include? 'provider' }
    @users.map{|u| u['email'] = keyed_view[u['id']]['email'] }

    if params[:format] == "csv"
      user_map = @users.map{|u| [u['email'], u['name'], u['company']['name']]}
      user_map.unshift ['email', 'name', 'company']
      render text: user_map.simple_csv
    else
      render :json => @users
    end
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