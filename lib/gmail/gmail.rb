require 'faraday'

module Gmail

  class Client

    def initialize(user)
      @email = user.email
      @credentials = user.credentials

      @conn = Faraday.new(:url => "https://www.googleapis.com/gmail/v1/users/#{@email}" ) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.headers = { 'Authorization' => "Bearer #{@credentials['access_token']}" }
        # faraday.use Faraday::Response::RaiseError
      end
    end

    def expired?
       Time.now.to_i - @credentials['expires_at'] > -10
    end

    def refresh!
      params = {
        client_id: ENV["GOOGLE_KEY"],
        client_secret: ENV["GOOGLE_SECRET"],
        grant_type: 'refresh_token',
        refresh_token: @credentials['refresh_token']
      }
      accounts = Faraday.new(:url => "https://accounts.google.com") do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
      resp = accounts.post 'o/oauth2/token', params

      if access_token = (JSON resp.body)['access_token']
        @credentials['access_token'] = access_token
        @conn.headers = { 'Authorization' => "Bearer #{@credentials['access_token']}" }
        @credentials
      else
        return false
      end
    end

    def get endpoint, params={}
      resp = @conn.get "#{base_url}/#{endpoint}", params
      return JSON resp.body
    end

    def post endpoint, params
      resp = @conn.post do |req|
        req.url "#{base_url}/#{endpoint}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def put endpoint, params
      resp = @conn.put do |req|
        req.url "#{base_url}/#{endpoint}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def delete endpoint
      resp = @conn.delete "#{base_url}/#{endpoint}"
      return JSON resp.body
    end

  end


end
