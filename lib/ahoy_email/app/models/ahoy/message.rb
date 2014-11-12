module Ahoy
  class Message < CouchRest::Model::Base

    property :token, String

    # user
    property :to, String
    property :user_id, String
    property :user_type, String

    # optional
    # feel free to remove
    property :mailer, String
    property :subject, String
    property :content, String

    # Gmail id, or from other service
    property :mailservice_id, String

    # timestamps
    property :sent_at, Time
    property :opened_at, Time
    property :clicked_at, Time

    belongs_to :lead, polymorphic: true

    design do
      view :by_token
      view :by_user_id
    end

    design do
      view :timestamps,
      :map =>
      "function(doc) {
      if (doc.type == 'Ahoy::Message') {
        var opened_at = (!!doc.opened_at) ? doc.opened_at : false;
        var clicked_at = (!!doc.clicked_at) ? doc.clicked_at : false;
        emit(doc.to, { mailservice_id: doc.mailservice_id, opened_at: opened_at, clicked_at: clicked_at });
      }
      };"
    end

    def self.timestamps_hash email
      h = Hash.new
      Ahoy::Message.timestamps.key(email).rows.map{|r| h[r['value']['mailservice_id']] = r['value']}
      h
    end

  end
end
