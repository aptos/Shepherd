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

  design do
    view :stats,
    :map =>
    "function(doc) {
      if (doc['type'] == 'Task') {
        emit([doc.owner, 'tasks'], 1)
      } else if (doc['type'] == 'Referral') {
        emit([doc.uid, 'referrals'], 1)
      } else if (doc['type'] == 'Bid') {
        emit([doc.owner, 'bids'], 1)
      } else if (doc['type'] == 'WorkOrder') {
        emit([doc.task_owner, 'work_orders'], 1)
        emit([doc.bid_owner, 'work_orders'], 1)
      }
      }",
    :reduce =>
    "_count"
  end

  def self.stats_by_uid
    @stats = self.stats.reduce.group_level(2).rows
    # create a stats hash from the view
    x = Hash.new {|h,k| h[k] = Hash.new}
    # init to zeros and map in stats
    @stats.map{|s| x[s["key"][0]] = {"bids"=>0, "tasks"=>0, "work_orders"=>0} }
    @stats.map{|s| x[s["key"][0]][s["key"][1]] = s["value"]}
    x
  end
end
