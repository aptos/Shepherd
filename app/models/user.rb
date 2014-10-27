class User < CouchRest::Model::Base
  property :uid, String
  property :provider, type: String, :default => 'linkedin'
  property :admin, TrueClass, :default => false, :read_only => true
  property :name, String
  property :positions, Array
  property :company, Hash
  property :email, type: String
  property :info, Hash
  property :skills, Array
  property :certifications, Array
  property :recommendations, Array
  property :documents, Hash
  property :s3_img_url, String
  property :current_location, Hash
  property :visits, Integer, default: 1
  unique_id :uid

  timestamps!

  proxied_by :site

  design do
    view :by_uid
  end

  design do
    view :by_created_at
  end

  design do
    view :summary,
    :map =>
    "function(doc) {
    if (doc['type'] == 'User') {
      var company = (!!doc.company) ? doc.company : '';
      var visits = (!!doc.visits) ? doc.visits : 1;

      emit(doc.uid, { id: doc.uid, name: doc.name, company: company, visits: visits, current_location: doc.current_location, updated_at: doc.updated_at, created_at: doc.created_at });
    }
    };"
  end

end
