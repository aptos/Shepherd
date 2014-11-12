class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
    # params['labelIds'] ||= ['INBOX']
    begin
      client = Gmail::Client.new current_user
      list = client.messages params
    rescue
      render :json => { error: 'Gmail client error' }, :status => 400 and return
    end

    # Fold in timestamps from Ahoy::Messages
    if list['messages'].length && params['q']
      timestamps = Ahoy::Message.timestamps_hash params['q']
      list['messages'].map do |m|
        if values = timestamps[m['id']]
          m['labelIds'] ||= []
          m['labelIds'] << 'UNREAD' unless values['opened_at']
          m['timestamps'] = values
        end
      end
    end

    render :json => list
  end

  def message
    id = params[:id]
    client = Gmail::Client.new current_user
    @message = client.get_message id

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
    @message = params[:gmail]
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
    message = Ahoy::Message.find payload["Ahoy-Message-Id"].to_s
    message.update_attributes(mailservice_id: response['id'])

    render :json => response
  end
end