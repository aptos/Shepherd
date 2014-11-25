class CampaignsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    summary = Ahoy::Message.summary.values
    @stats = {
      sent: summary.count,
      opened: summary.select{|r| r['opened_at']}.count,
      clicked: summary.select{|r| r['clicked_at']}.count
    }

    by_template = Ahoy::Message.by_template_and_subject.reduce.group_level(2).rows
    @stats[:template_stats] = by_template.map{|t| {
      template: t['key'][0],
      subject: t['key'][1],
      sent: t['value'][0],
      opened: t['value'][1],
      clicked: t['value'][2]
      }
    }

    render :json => @stats
  end

end