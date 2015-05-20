require 'couchrest/model'
CouchServer = CouchRest::Server.new # defaults to localhost:5984
# CouchServer.default_database = "appname-#{Rails.env}"

class  CouchRest::Model::Designs::View

  def as_hash key
    keyed_view = Hash.new
    self.rows.map{|r| keyed_view[r['value'][key]] = r['value']}
    keyed_view
  end

  def values
    self.rows.map{|r| r['value'] }
  end
end


# Adding supported databases
Shepherd::Application.configure do
  config.sites = [
    { db: 'taskit2015', label: 'TaskIT'},
    { db: 'taskit-juniper', label: 'Juniper'}
  ]
end

Shepherd::Application.config.sites.each do |site|
  Rails.logger.info "****  Creating db slug for #{site[:label]}"
  slug = Site.by_slug.key("#{site[:db]}_#{Rails.env}").first
  slug ||= Site.create(slug: "#{site[:db]}_#{Rails.env}", name: site[:label] )
end

