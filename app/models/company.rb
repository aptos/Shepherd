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
    view :by_domain
  end

  design do
    view :locations,
    :map =>
    "function(doc) {
    if (doc.type == 'Company') {
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      if (!!doc.name) emit(doc.name, {
        id: doc._id,
        locations: locations,
        logo: logo,
        website_url: doc.website_url });
      }
      };"
  end

  ##
  # TaskIT App
  design do
    view :summary,
    :map =>
    "function(doc) {
    if (doc.type == 'Company' && doc.name) {
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var employee_count_range = (typeof(doc.employee_count_range) != 'undefined' ) ? doc.employee_count_range.name : '';
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      var specialties = (typeof(doc.specialties) != 'undefined' ) ? doc.specialties.all : '';
      var skills = (typeof(doc.skills) != 'undefined' ) ? doc.skills : [];
      var domain = (!!doc.domain) ? doc.domain : doc._id;
      emit(doc.name, {
        id: doc._id,
        domain: domain,
        name: doc.name,
        description: doc.description,
        employee_count_range: employee_count_range,
        founded_year: doc.founded_year,
        locations: locations,
        specialties: specialties,
        skills: skills,
        website_url: doc.website_url,
        logo: logo,
        pending: doc.pending });
      }
      };"
  end

  design do
    view :skills,
    :map =>
    "function(doc) {
    if (doc.type == 'Company') {
      var locations = (typeof(doc.locations) != 'undefined' ) ? doc.locations.all : '';
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      if (doc.skills) {
        doc.skills.forEach(function(skill) {
          emit(skill, { id: doc._id, name: doc.name, locations: locations, logo: logo});
        });
      }
      if (doc.badges) {
        Object.keys(doc.badges).forEach(function(badge) {
          emit(badge, { id: doc._id, name: doc.name, locations: locations, logo: logo});
        });
      }
      if (doc.specialties) {
        doc.specialties.all.forEach(function(specialty) {
          emit(specialty, { id: doc._id, name: doc.name, locations: locations, logo: logo});
        });
      }
      }
    }",
    :reduce => "_count"
  end
end