class Analytic < CouchRest::Model::Base
  property :action, String
  property :search, String
  property :hits, Integer
  property :state, String
  property :uid, String, default: 'guest'
  property :location, Hash

  timestamps!

  proxied_by :site

  design do
    view :by_created_at
    view :searches,
      :map =>
      "function(doc) {
        if (doc.type == 'Analytic' && doc.action == 'search') {
          emit(doc.search, { search: doc.search, hits: doc.hits, state: doc.state, user: doc.uid });
        }
      }",
      :reduce => "_count"
  end

end