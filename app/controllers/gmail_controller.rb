class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox
		client = Gmail::Client.new current_user
		list = client.messages params

		render :json => list
	end
end