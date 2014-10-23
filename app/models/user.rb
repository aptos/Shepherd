class User < CouchRest::Model::Base
  property :uid, String
  property :provider, type: String, :default => 'linkedin'
  property :admin, TrueClass, :default => false, :read_only => true
  property :name, String
  property :positions, Array
  property :company, Hash
  property :email, type: String
  property :info, Hash
  property :address, Hash
  property :skills, Array
  property :certifications, Array
  property :recommendations, Array
  property :documents, Hash
  property :s3_img_url, String
  property :current_location, Hash
  property :visits, Integer, default: 1
  unique_id :uid

  design do
    view :by_uid
  end

  design do
    view :by_email
  end

  design do
    view :by_company,
    :map =>
    "function(doc) {
    if (doc['type'] == 'User' && doc.company) {
      emit(doc.company.id, { id: doc.uid, text: doc.name });
    }
    };"
  end

  design do
    view :by_created_at
  end
end