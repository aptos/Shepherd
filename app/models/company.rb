class Company < CouchRest::Model::Base
  property :_id, String
  property :owner, String
  property :description, String
  property :employee_count_range, Hash
  property :founded_year, Integer
  property :id, String  # Normally, an Integer is returned by linkedin. Protect ability to use non-linkedin with String model
  property :locations, Hash
  property :logo_url, String
  property :name, String
  property :num_followers, Integer
  property :specialties, Hash
  property :skills, Array
  property :square_logo_url, String
  property :twitter_id, String
  property :website_url, String
  property :s3_logo_url, String
  property :industries, Hash
  property :ticker, String
  property :badges, Hash
  property :profiles, Array
  timestamps!

  proxied_by :site

  design do
    view :by_name
  end

  design do
    view :locations,
    :map =>
    "function(doc) {
    if (doc['type'] == 'Company') {
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      if (!!doc.name) emit(doc.name, { id: doc._id, locations: locations, logo: logo, website_url: doc.website_url });
      }
      };"
  end

end