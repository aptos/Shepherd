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
    view :by_company,
    :map =>
    "function(doc) {
    if (doc['type'] == 'User' && doc.company) {
      emit(doc.company.id, { id: doc.uid, text: doc.name });
    }
    };"
  end

  ####
  # Views for Shepherd app

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
    view :activity,
    :map =>
    "function(doc) {
    if (doc.type == 'Task') {
      emit([doc.owner, doc.created_at, 'Project', 'posted'], {id: doc._id, type: 'tasks', title: doc.title, task_owner: doc.owner_name, status: doc.status})
      } else if (doc.type == 'Bid') {
        emit([doc.owner, doc.created_at, doc.type, 'posted'], {id: doc._id, type: 'bids', title: doc.task_title, task_owner: doc.task_owner_name, status: doc.status })
        } else if (doc.type == 'WorkOrder') {
          if (doc.work_accepted_date) {
            emit([doc.task_owner, doc.work_accepted_date, doc.type, 'work accepted'], {id: doc._id, type: 'work_orders',title: doc.task_title, task_owner: doc.task_owner_name, bid_owner: doc.bid_owner_name} )
            emit([doc.bid_owner, doc.work_accepted_date, doc.type, 'work accepted'], {id: doc._id, type: 'work_orders',title: doc.task_title, task_owner: doc.task_owner_name, bid_owner: doc.bid_owner_name} )
          }
        }
        };"
      end

  design do
    view :stats,
    :map =>
    "function(doc) {
    if (doc['type'] == 'Task') {
      emit([doc.owner, 'tasks'], 1)
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

end