class Note < CouchRest::Model::Base
  property :_id, String
  property :name, String
  property :uid, String
  property :site, String
  property :owner, String
  property :details, String
  property :due_date, Date
  property :completed, TrueClass, :default => false

  timestamps!

  design do
    view :by_uid
  end

  design do
    view :reminders,
    :map =>
    "function(doc) {
    if (doc.type == 'Note' && !!doc.due_date & !doc.completed) {
      emit(doc.uid, doc);
    }
    };"
  end
end