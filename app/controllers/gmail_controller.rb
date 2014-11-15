class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
    begin
      client = Gmail::Client.new current_user
      @list = client.messages params
    rescue
      render :json => { error: 'Gmail client error' }, :status => 400 and return
    end

    @list['messages'] ||= []

    # Fold in timestamps from Ahoy::Messages
    if params['q']
      summary = Ahoy::Message.summary.key(params['q']).as_hash('mailservice_id')
      @list['messages'].map do |m|
        if values = summary[m['id']]
          m['labelIds'] ||= []
          m['labelIds'] << 'UNREAD' unless values['opened_at']
          m['timestamps'] = [values['opened_at'], values['clicked_at']]

          summary.delete m['id']
        end
      end

      # Add ahoy message summaries from other Admins
      if summary.length
        summary.values.each do |message|
          m = {
            id: message['mailservice_id'],
            labelIds: ["SENT","SUMMARY"],
            date: message["sent_at"],
            subject: message['subject'],
            from: message['from']
          }
          m[:labelIds] << 'UNREAD' unless message['opened_at']
          m[:labelIds] << 'CLICKED' if message['clicked_at']

          @list['messages'] << m
        end
      end
    end

    render :json => @list
  end

  def message
    id = params[:id]
    client = Gmail::Client.new current_user
    @message = client.get_message id

    render :json => { error: 'message not found' }, :status => 404 and return unless @message

    # remove all images - especially our tracer that will trigger opened_at when rendered!
    @message[:body].gsub!(/<img .*?>/,'')

    # add ahoy data
    if @message['metadata'] = Ahoy::Message.by_mailservice_id.key(id).first
      @message['labelIds'] ||= []
      @message['labelIds'] << 'UNREAD' unless @message['metadata']['opened_at']
    end

    render :json => @message
  end

  def send_message
    @message = params[:gmail][:new_message]

    if template = params[:gmail]['template']
      EmailTemplate.update template, @message
    end

    @message['to'] = params[:uid]
    @message['from'] = current_user.email
    @message['from_name'] = current_user.name
    client = Gmail::Client.new current_user

    payload = Gmailer.standard_email(@message)
    Rails.logger.info "*** Sending Email\n\n #{payload}"
    begin
      encoded_payload = Base64.urlsafe_encode64 payload.to_s
      response = client.send_message encoded_payload
    rescue
      render :json => { error: 'Gmail client error', message: response }, :status => 400 and return
    end

    # Update message with gmail id
    ahoy_message = Ahoy::Message.find payload["Ahoy-Message-Id"].to_s
    ahoy_message.update_attributes(mailservice_id: response['id'], sent_at: Time.now)
    render :json => response
  end

  def templates
    render :json => EmailTemplate.by_name.all
  end

end