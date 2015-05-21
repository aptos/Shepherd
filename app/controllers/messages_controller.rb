class MessagesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    summary = Ahoy::Message.summary.values
    @stats = {
      sent: summary.count,
      opened: summary.select{|r| r['opened_at']}.count,
      clicked: summary.select{|r| r['clicked_at']}.count,
      template_stats: []
    }

    Ahoy::Message.by_template_and_subject.reduce.group_level(1).rows.each do |row|
      name = row['key'].first
      stats = row['value']
      messages_by_template = Ahoy::Message.by_template_and_subject.startkey([name]).endkey([name,{}]).reduce.group_level(2).rows
      messages = messages_by_template.map{|m|
        {
          subject: m['key'][1],
          sent: m['value'][0],
          opened: m['value'][1],
          clicked: m['value'][2],
          updated: last_used(m['key'])
        }
      }
      @stats[:template_stats].push({ name: name, stats: stats, messages: messages })
    end

    sent_templates = @stats[:template_stats].map{|t| t[:name]}.uniq
    all_templates =  EmailTemplate.by_name.all.map{|t| t[:name]}.uniq
    (all_templates - sent_templates).map{|t| @stats[:template_stats].push({ name: t, stats: [0,0,0], messages: [] }) }

    render :json => @stats
  end

  def template
    name = params[:name]
    template = EmailTemplate.by_name.key(name).first
    template ||= EmailTemplate.new( :name => name )
    render :json => template
  end

  def update_template
    name = params[:name]
    message = {
      'subject' => params[:subject],
      'body' => params[:body]
    }
    unless params[:subject].length > 1 && params[:body].length > 10
      render :json => { error: "template update requires subject and body content" }, :status => 400 and return
    end

    template = EmailTemplate.update name, message, false
    render :json => template
  end

  private

  def last_used key
    (t,s) = key
    Ahoy::Message.by_template_and_subject.startkey([t,s]).endkey([t,s,{}]).last['updated_at'] rescue nil
  end

end