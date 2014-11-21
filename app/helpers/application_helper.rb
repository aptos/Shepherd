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

  def hipchat
    @hipchat ||= HipChat::Client.new(Shepherd::Application.config.hipchat[:token])[Shepherd::Application.config.hipchat[:room]]
  end


  def gmail_client
    gmail = Gmail()
    if gmail.expired?
      self.credentials = gmail.refresh!
      self.save
    end

    gmail
  end

end