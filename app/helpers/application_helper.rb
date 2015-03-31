module ApplicationHelper
	#
	# about our user
	#
	def current_user
    @current_user ||= Admin.by_auth_token.key(cookies[:auth_token]).first if cookies[:auth_token]
  end

  def mobile_device?
    logger.info "**** Mobile? #{request.user_agent}"
    if params[:mobile_override]
    	params[:mobile_override] == "1"
    else
    	(request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end

  def site
    db_name = cookies[:site] || Shepherd::Application.config.sites.first[:db]
    Rails.logger.info "DB: #{db_name}"
    unless @site
      @site = Site.by_slug.key("#{db_name}_#{Rails.env}").first
      @site ||= Site.create(slug: "#{db_name}_#{Rails.env}" )
    end
    @site
  end

  def site_name
    db_name = site.slug.split("_").first
    Shepherd::Application.config.sites.find{|s| s[:db] == db_name}[:label]
  end

  def gmail_client
    gmail = Gmail()
    if gmail.expired?
      self.credentials = gmail.refresh!
      self.save
    end

    gmail
  end

  def recent_users days, db_name
    site = Site.by_slug.key("#{db_name}_#{Rails.env}").first
    last_week = Date.today - days.to_i

    users = site.users.by_created_at.descending().limit(100).rows.keep_if {|u| last_week < Date.parse(u['key']) }
    users.map do |user|
      user[:profile] = site.users.find(user['id'])
    end

    users
  end

  def current_projects db_name
    site = Site.by_slug.key("#{db_name}_#{Rails.env}").first
    projects = site.tasks.summary.rows.select{|r| ['Open','Invitation'].include? r['value']['status'] }
    projects.map{|p| p['value'] }
  end

end