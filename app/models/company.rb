class Company < CouchRest::Model::Base
  property :_id, String
  property :id, String # this is the Linkedin id
  property :name, String
  property :seo_name, String
  property :owner, String
  property :description, String
  property :employee_count_range, Hash
  property :founded_year, Integer
  property :locations, Hash
  property :logo_url, String
  property :specialties, Hash
  property :skills, Array
  property :website_url, String
  property :domain, String
  property :s3_logo_url, String
  property :badges, Hash
  property :pending, TrueClass, default: false
  property :views, Integer, default: 0
  timestamps!

  proxied_by :site

  ##
  # Shepherd App
  design do
    view :by_name
    view :by_seo_name
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
    if (doc.type == 'Company' && doc.name && !doc.pending) {
      var logo = (!!doc.s3_logo_url) ? doc.s3_logo_url : '';
      var employee_count_range = (typeof(doc.employee_count_range) != 'undefined' ) ? doc.employee_count_range.name : '';
      var locations = '';
      var cities = '';
      if (typeof(doc.locations) != 'undefined' ) {
        locations = doc.locations;
        cities = locations.all.map(function(loc) { return loc.address.city; });
      }
      var specialties = (typeof(doc.specialties) != 'undefined' ) ? doc.specialties.all : '';
      var skills = (typeof(doc.skills) != 'undefined' ) ? doc.skills : [];
      var domain = (!!doc.domain) ? doc.domain : doc._id;
      var seo_name = (!!doc.seo_name) ? doc.seo_name : doc.name.toLowerCase().replace(/[\\s\\.,]+/g, '-').replace(/-+$/,'');
      emit(doc.name, {
        id: doc._id,
        domain: domain,
        name: doc.name,
        seo_name: seo_name,
        description: doc.description,
        employee_count_range: employee_count_range,
        founded_year: doc.founded_year,
        locations: locations,
        cities: cities,
        specialties: specialties,
        skills: skills,
        website_url: doc.website_url,
        logo: logo,
        views: doc.views,
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