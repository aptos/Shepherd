class LeadsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  ## NOTE: lead access is always by UID, which maps to User model email
  def show
    lead = Lead.by_uid.key(params[:uid]).first

    Rails.logger.info "Here is your lead: #{lead.inspect}"

    render :json => lead
  end

  def create
    new_lead = params[:lead]
    if Lead.by_uid.key(new_lead[:email]).first
      render :json => { error: 'duplicate email address'}, :status => 403 and return
    end

    lead = Lead.new(
      uid: new_lead[:email],
      site: site_name,
      info: new_lead[:info]
    )
    lead.save!

    render :json => lead
  end

  def update
    lead = Lead.by_uid.key(params[:uid]).first
    if lead
      lead.attributes = params[:lead]
    else
      lead = Lead.new(params[:lead])
    end

    lead.save!

    render :json => lead
  end

  def notes
    @notes = Note.by_uid.key(params[:uid])

    render :json => @notes
  end

end