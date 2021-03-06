class Site < CouchRest::Model::Base
  property :name
  property :slug

  proxy_for :users
  proxy_for :settings
  proxy_for :tasks
  proxy_for :companies
  proxy_for :campaigns
  proxy_for :analytics

  design do
    view :by_slug
  end

  # Databased are on same server
  def proxy_database
    @db ||= self.server.database!(slug)
  end

end