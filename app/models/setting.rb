class Setting < CouchRest::Model::Base
  property :uid, String
  property :name, String
  property :role, String, :default => "Buyer"
  property :entity, String, :default => "Company"
  property :company_id, String
  property :company_list_admin, String, :read_only => true
  property :contact, Hash
  property :latLong, Array
  property :email_notifications, TrueClass, :default => true
  property :bank_account, Hash
  property :credit_card, Hash
  property :credentials, Hash
  property :referral, String
  property :company_invite_token, String

  proxied_by :site

  design do
    view :by_uid
  end

  design do
    view :summary,
      :map =>
      "function(doc) {
        if (doc['type'] == 'Setting') {
          var latLong = (!!doc.latLong) ? doc.latLong : '';
          emit(
            doc.uid,
            { uid: doc.uid, name: doc.name, email: doc.contact.email, email_notifications: doc.email_notifications, role: doc.role, entity: doc.entity, company_id: doc.company_id, latLong: latLong  }
            );
        }
      };"

  end

end