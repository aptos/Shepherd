class Lead < CouchRest::Model::Base
  property :_id, String
  property :uid, String
  property :name, String
  property :status, String, :default => 'New'
  property :last_contacted, Date

  timestamps!

  design do
    view :by_uid
  end
end