class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @users = site.users.summary.rows.map{|r| r['value']}

    # add lead
    leads = Hash.new
    Lead.by_uid.map{|r| leads[r[:uid]] = r.to_hash.slice('segment','info')}

    # add stats
    stats = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
    site.users.stats.reduce.group_level(2).rows.map{|r| stats[r['key'][0]][r['key'][1]] = r['value'] }

    # add settings provider role
    provider = Hash.new
    site.settings.by_uid.all.map{|r| provider[r['uid']] = r['roles'].include?('provider') }

    # create segments array
    @users.map do |u|
      u[:lead] = leads[u['id']]
      u[:stats] = stats[u['id']]
      u[:segment] = u[:lead]['segment'] if u[:lead]
      u[:segments] = []
      u[:segments].push u[:lead]['segment'] if u[:lead]
      u[:segments].push "Provider" if provider[u['id']]
      u[:role] = "Provider" if provider[u['id']]
      u[:active] = "Active" if u['visits'] > 5
      u[:new] = "New" if u['created_at'].to_date > 30.days.ago
    end

    render :json => @users
  end

  def summary
    slug = Site.by_slug.key("taskit2015_#{Rails.env}").first
    taskit_users = slug.users.summary.rows.map{|r|
      co = (r['value']['company']) ? r['value']['company']['name'] : ''
      { id: r['key'], name: r['value']['name'], company: co}
    }

    # id: user.id, name: user.name, company: user.company.name

    slug = Site.by_slug.key("taskit-juniper_#{Rails.env}").first
    juniper_users = slug.users.summary.rows.map{|r|
      co = (r['value']['company']) ? r['value']['company']['name'] : ''
      { id: r['key'], name: r['value']['name'], company: co}
    }

    @users = (taskit_users + juniper_users).uniq.sort_by{|u| u['id']}
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
    slug = Site.by_slug.key("taskit2015_#{Rails.env}").first
    user = slug.users.find(params[:id])
    unless user
      slug = Site.by_slug.key("taskit-juniper_#{Rails.env}").first
      user = slug.users.find(params[:id])
    end
    unless user
      render :json => { error: "user not found #{params[:id]}"}, status: 404 and return
    end
    settings = slug.settings.by_uid.key(params[:id]).first
    user['last_visit'] = user.updated_at
    user['site'] = slug.name
    user.merge! settings

    render :json => user
  end

  def activity
    key = params[:id]

    slug = Site.by_slug.key("taskit2015_#{Rails.env}").first
    taskit_tasks = slug.users.activity.startkey([key]).endkey([key,{},{},{}]).rows
    taskit_tasks.map{|t|
      type = (t['key'][2] == 'Bid') ? "projects/proposals" : "projects"
      t['url'] = "https://www.taskit.io/#{type}/show/#{t['id']}"
    }

    slug = Site.by_slug.key("taskit-juniper_#{Rails.env}").first
    juniper_tasks = slug.users.activity.startkey([key]).endkey([key,{},{},{}]).rows
    juniper_tasks.map{|t|
      type = (t['key'][2] == 'Bid') ? "projects/proposals" : "projects"
      t['url'] = "https://juniper.taskit.io/#{type}/show/#{t['id']}"
    }

    @activities = taskit_tasks + juniper_tasks

    @activities = [] unless @activities

    render :json => @activities
  end

end