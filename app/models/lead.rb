class Lead < CouchRest::Model::Base
  property :_id, String
  property :uid, String
  property :site, String
  property :segment, String, :default => 'Onboard'
  property :last_contacted, Date

  timestamps!

  design do
    view :by_uid
  end

end