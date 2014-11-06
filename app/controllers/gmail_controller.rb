class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
    client = gmail_client

		messages = client.get 'messages'

		render :json => messages
	end
end