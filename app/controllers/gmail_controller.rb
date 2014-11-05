class GmailController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def inbox

		@conn = Faraday.new(:url => "https://www.googleapis.com/gmail/v1/users/brian@taskit.io" ) do |faraday|
			faraday.request  :url_encoded  
			faraday.adapter  Faraday.default_adapter
			# faraday.use Faraday::Response::RaiseError
		end

    refresh

		Rails.logger.info "Connection: #{@conn.inspect}"

		messages = @conn.get 'messages'

		render :json => messages
	end
end

private
def refresh

	params = {
		client_id: ENV["GOOGLE_KEY"],
		client_secret: ENV["GOOGLE_SECRET"],
		grant_type: 'refresh_token',
		refresh_token: current_user.credentials['refresh_token']
	}

	accounts = Faraday.new(:url => "https://accounts.google.com") do |faraday|
		faraday.request  :url_encoded
		faraday.adapter  Faraday.default_adapter
	end

	resp = accounts.post 'o/oauth2/token', params

  Rails.logger.info (JSON resp.body)

	access_token = (JSON resp.body)['access_token']
	@conn.headers = { 'Authorization' => "Bearer #{access_token}" }
	@conn
end