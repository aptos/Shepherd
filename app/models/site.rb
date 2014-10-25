class Site < CouchRest::Model::Base
  property :name
  property :slug

  proxy_for :users
  proxy_for :settings
  proxy_for :tasks
  proxy_for :companies

  # Databased are on same server
  def proxy_database
    @db ||= self.server.database!(slug)
  end

end