class Note < CouchRest::Model::Base
  property :_id, String
  property :uid, String
  property :owner, String
  property :details, String
  property :due_date, Date

  timestamps!

  design do
    view :by_uid
  end

  design do
    view :reminders,
    :map =>
    "function(doc) {
    if (doc.type == 'Note' && !!doc.due_date) {
      emit(doc.uid, doc);
    }
    };"
  end
end