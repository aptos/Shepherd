class Lead < CouchRest::Model::Base
  property :_id, String
  property :uid, String
  property :site, String
  property :segment, String, :default => 'Onboard'
  property :info, Hash

  timestamps!

  design do
    view :by_uid
  end

  def self.from_uid(uid)
    lead = self.by_uid.key(uid).first
    unless lead
      lead = Lead.new(uid: uid)
      lead.save
    end
    lead
  end

  # has_many :messages, class_name: "Ahoy::Message"
  def messages
    Ahoy::Messages.by_user_id.key(self._id)
  end

end