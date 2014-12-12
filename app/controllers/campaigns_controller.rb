class CampaignsController < ApplicationController
  respond_to :json

  # show all referrals for current user
  def index
    @campaigns = Campaign.by_utm_campaign.all
    render :json => @campaigns
  end

  def create
    @campaign = Campaign.create params[:utm_campaign]
    render :json => @campaign
  end

  def show
    id = "utm_campaign:#{params[:utm_campaign]}"
    @campaign = Campaign.find(id)
    unless @campaign
      render :json => { error: "campaign not found: #{params[:utm_campaign]}" }, :status => 404 and return
    end
    render :json => @campaign
  end

end