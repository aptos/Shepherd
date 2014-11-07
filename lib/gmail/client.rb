require 'faraday'

module Gmail

  class Client

    attr_accessor :conn

    def initialize(user)
      @email = user.email
      @credentials = user.credentials

      @conn = Faraday.new(:url => "https://www.googleapis.com/gmail/v1/users/#{@email}" ) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.headers = { 'Authorization' => "Bearer #{@credentials['token']}" }
        faraday.use Faraday::Response::RaiseError
      end

      if expired?
        user.credentials = refresh!
        user.save!
      end
    end

    def expired?
      Time.now.to_i - @credentials['expires_at'] > -10 rescue true
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

      if auth = (JSON resp.body)
        @credentials['token'] = auth['access_token']
        @credentials['expires_at'] = auth['expires_in'] + Time.now.to_i
        @conn.headers = { 'Authorization' => "Bearer #{@credentials['token']}" }
        @credentials
      else
        return false
      end
    end

    def get endpoint, params={}
      resp = @conn.get endpoint, params
      return JSON resp.body
    end

    def post endpoint, params
      resp = @conn.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def put endpoint, params
      resp = @conn.put do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def delete endpoint
      resp = @conn.delete endpoint
      return JSON resp.body
    end

    def messages params
      query = { maxResults: 8 }
      ['labelIds','maxResults','pageToken','q'].each {|k| query[k.to_sym] = params[k] if params.has_key? k}
Rails.logger.info "***************    params: #{query.inspect}"
      list = get 'messages', query

      if list['messages']
        list['messages'].map do |m|
          if message = get("messages/#{m['id']}", { format: 'metadata', metadataHeaders: 'Date'})
            message['date'] = message['payload']['headers'][0]['value'] rescue nil
            message.delete 'payload'
            m.merge! message
          end
        end
      end

      list
    end

  end


end
