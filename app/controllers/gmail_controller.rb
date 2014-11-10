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
    message = client.get_message id

    render :json => message
  end
end