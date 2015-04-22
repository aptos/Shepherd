class Setting < CouchRest::Model::Base
  property :uid, String
  property :name, String
  property :roles, Array, :default => ["user"]
  property :email, String
  property :address, String
  property :latLong, Array
  property :phone, String
  property :credentials, Hash

  timestamps!

  proxied_by :site

  design do
    view :by_uid
    view :by_email
  end

end