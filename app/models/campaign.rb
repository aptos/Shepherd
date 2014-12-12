class Campaign < CouchRest::Model::Base
  property :utm_campaign, String
  property :utm_source, Hash, :default => {}
  property :utm_medium, Hash, :default => {}
  property :utm_content, Hash, :default => {}
  property :views, Integer, :default => 0

  unique_id :utm_campaign
  timestamps!

  proxied_by :site

  # def self.create utm_campaign
  #   id = URI.escape "utm_campaign:#{utm_campaign}"
  #   if campaign = Campaign.find(id)
  #     return campaign
  #   end

  #   create! do |c|
  #     c.utm_campaign = id
  #   end
  # end

  design do
    view :by_utm_campaign
  end
end