class SessionsController < ApplicationController

  def new
    if params[:provider]
      provider = params[:provider]
      auth_url = "/auth/#{provider}"
      redirect_to auth_url
    else
      logger.info "no provider provided"
    end
  end

  def create
    email = env['omniauth.auth']['info']['email'] rescue nil
    unless email =~ /.*@(.*)/ && $1 == "taskit.io"
      redirect_to "/" and return
    end
    admin = Admin.from_omniauth(env["omniauth.auth"])
    cookies.permanent[:auth_token] = admin.auth_token

    url = '/'
    url = root_path if url.eql?('/signout')

    session[:user_id] = admin.id

    redirect_to url
  end

  def change_site
    cookies.permanent[:site] = params[:site]
    @site = Site.create(slug: "#{params[:site]}_#{Rails.env}")
    Rails.logger.info "SITE CHANGED: db is #{@site.inspect}"
    render :json => { ok: true, site: params[:site] }
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
    redirect_to root_url
  end

  def failure
    message = "Unknown Error"
    if params[:message]
      message = params[:message].humanize
    end
    redirect_to root_url, :alert => "Authentication error: #{message}"
  end

end