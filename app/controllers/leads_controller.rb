class LeadsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  ## NOTE: lead access is always by UID, which maps to User model email
  def show
    lead = Lead.by_uid.key(params[:uid]).first

    Rails.logger.info "Here is your lead: #{lead.inspect}"

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

end