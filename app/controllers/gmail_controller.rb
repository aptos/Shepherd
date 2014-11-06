class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
    client = Gmail::Client.new current_user

		messages = client.get 'messages'

		render :json => messages
	end
end