class MessagesController < ApplicationController
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
      clicked: t['value'][2],
      updated: last_used(t['key'])
      }
    }

    render :json => @stats
  end

  def template
    name = params[:name]
    template = EmailTemplate.by_name.key(name).first
    unless template
      render :json => { error: "template not found: #{params[:name]}" }, :status => 404 and return
    end
    render :json => template
  end

  private

  def last_used key
    (t,s) = key
    Ahoy::Message.by_template_and_subject.startkey([t,s]).endkey([t,s,{}]).last['updated_at'] rescue nil
  end

end