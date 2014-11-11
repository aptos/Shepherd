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

    # timestamps
    property :sent_at, Time
    property :opened_at, Time
    property :clicked_at, Time

    belongs_to :lead, polymorphic: true

    design do
      view :by_token
      view :by_user_id
    end

  end
end
