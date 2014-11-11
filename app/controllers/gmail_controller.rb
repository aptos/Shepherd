class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
    begin
      client = Gmail::Client.new current_user
      list = client.messages params
    rescue
      render :json => { error: 'Gmail client error' }, :status => 400 and return
    end

    render :json => list
  end

  def message
    id = params[:id]
    client = Gmail::Client.new current_user
    @message = client.get_message id

    render :json => @message
  end

  def send_message
    @message = params[:gmail]
    @message['to'] = params[:uid]
    @message['from'] = current_user.email
    @message['from_name'] = current_user.name
    client = Gmail::Client.new current_user

    payload = Gmailer.standard_email(@message).to_s
    Rails.logger.info "*** Sending Email\n\n #{payload}"
    begin
      encoded_payload = Base64.urlsafe_encode64 payload
      response = client.send_message encoded_payload
    rescue
      render :json => { error: 'Gmail client error', message: response }, :status => 400 and return
    end
    render :json => response
  end
end