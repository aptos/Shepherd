class Campaign < CouchRest::Model::Base
  property :utm_campaign, String
  property :utm_source, Hash, :default => {}
  property :utm_medium, Hash, :default => {}
  property :utm_content, Hash, :default => {}
  property :views, Integer, :default => 0

  unique_id :utm_campaign
  timestamps!

  proxied_by :site

  design do
    view :by_campaign_and_day,
    :map =>
    "function(doc) {
    if (doc.type == 'Campaign') {
      var d = new Date(Date.parse(doc.created_at));
      emit([doc.utm_campaign, d.getFullYear(), d.getMonth() + 1, d.getDate()], doc);
      }
      };"
  end

end