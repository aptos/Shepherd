module ApplicationHelper
	#
	# about our user
	#
	def current_user
    @current_user ||= User.by_auth_token.key(cookies[:auth_token]).first if cookies[:auth_token]
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
		if !(current_user || auth_with_token)
			redirect_to root_url, :alert => 'You need to sign in for access to this page.'
		end
	end

	def auth_with_token
		authenticate_with_http_token do |token, options|
			session[:user_id] = Setting.find(token).uid rescue nil
			logger.warn "AUTH_WITH_TOKEN: '#{token}'"
		end
		return true if session[:user_id]
	end


end
