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

  timestamps!

  proxied_by :site

  design do
    view :by_uid
    view :by_email
  end

end