class CampaignsController < ApplicationController
  respond_to :json

  # show all referrals for current user
  def index
    @campaigns = site.campaigns.by_campaign_and_day.all
    render :json => @campaigns
  end

  def show
    unless id = params[:utm_campaign]
      render :json => { error: "utm_campaign parameter is required" }, :status => 400 and return
    end
    @campaign = site.campaigns.by_campaign_and_day.startkey([id]).endkey([id,{},{},{}]).all
    unless @campaign
      render :json => { error: "campaign not found: #{params[:utm_campaign]}" }, :status => 404 and return
    end

    render :json => @campaign
  end

end