class Task < CouchRest::Model::Base
  property :_id, String
  property :owner, String
  property :owner_name, String
  property :owner_title, String
  property :team, Array
  property :company, String
  property :title, String
  property :description, String
  property :service_id, String
  property :start_date, type: Date
  property :location, String
  property :latLong, Array
  property :tags, Array
  property :status, String, :default => "Open"
  property :attachments, Hash
  property :accepted_bid, String
  property :bid_owner, String
  property :bid_owner_name, String
  property :work_order_id, String
  property :views, Integer, :default => 0
  property :edited_at, Time, :default => Time.now

  timestamps!

  proxied_by :site

  design do
    view :summary,
    :map =>
    "function(doc) {
      if (doc['type'] == 'Task' && (doc['owner'] != null) && (doc['status'] != null)) {
        var company = (!!doc.company) ? doc.company : '';
        var location = (!!doc.location) ? doc.location : '';
        var start_date = (!!doc.start_date) ? doc.start_date : '';
        var work_order_id = (!!doc.work_order_id) ? doc.work_order_id : '';
        var description = (doc.description.length > 300) ? doc.description.substring(0,300) + '...' : doc.description;
        var team = (!!doc.team) ? doc.team.map(function(m){ return m.id}).concat(doc.owner) : [doc.owner];
        team.forEach(function(m) {
          emit([m, doc.status], {
            id: doc._id,
            title: doc.title,
            location: location,
            start_date: start_date,
            owner: doc.owner,
            team: doc.team,
            status: doc.status,
            description: description,
            accepted_bid: doc.accepted_bid,
            work_order_id: work_order_id,
            views: doc.views,
            created_at: doc.created_at
          });
        })
      };
    }"
  end

  design do
    view :by_owner
    view :by_status
  end

end