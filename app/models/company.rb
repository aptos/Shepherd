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

  ##
  # Shepherd App
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

  ##
  # TaskIT App
  design do
    view :summary,
    :map =>
    "function(doc) {
    if (doc['type'] == 'Company') {
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var employee_count_range = (typeof(doc.employee_count_range) != 'undefined' ) ? doc.employee_count_range.name : '';
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      var industries = (typeof(doc.industries) != 'undefined' ) ? doc.industries.all : '';
      var specialties = (typeof(doc.specialties) != 'undefined' ) ? doc.specialties.all : '';
      var skills = (typeof(doc.skills) != 'undefined' ) ? doc.skills : [];
      var partnerships = (typeof(doc.partnerships) != 'undefined' ) ? doc.partnerships : '';
      if (!!doc.name) emit(doc.name, { id: doc._id, description: doc.description, employee_count_range: employee_count_range, founded_year: doc.founded_year, ticker: doc.ticker, locations: locations, industries: industries, specialties: specialties, skills: skills, website_url: doc.website_url, logo: logo, partnerships: partnerships });
      }
      };"
  end

  design do
    view :skills,
    :map =>
    "function(doc) {
    if (doc['type'] == 'Company') {
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var partnerships = (typeof(doc.partnerships) != 'undefined' ) ? doc.partnerships : '';
      if (doc['skills']) {
        doc.skills.forEach(function(skill) {
          emit(skill, { id: doc._id, name: doc.name, locations: locations, logo: logo, partnerships: partnerships});
          });
    }
    if (doc['specialties']) {
      doc.specialties.all.forEach(function(specialty) {
        emit(specialty, { id: doc._id, name: doc.name, locations: locations, logo: logo, partnerships: partnerships});
        });
    }
    }
    }"
  end
end