module Ahoy
  class Message < CouchRest::Model::Base

    property :token, String

    # user
    property :to, String
    property :user_id, String
    property :user_type, String

    # optional
    # feel free to remove
    property :from, String
    property :mailer, String
    property :subject, String
    property :content, String

    property :template, String

    # Gmail id, or from other service
    property :mailservice_id, String

    # timestamps
    property :sent_at, Time
    property :opened_at, Time
    property :clicked_at, Time

    timestamps!

    belongs_to :lead, polymorphic: true

    design do
      view :by_token
      view :by_user_id
      view :by_mailservice_id
    end

    design do
      view :by_template_and_subject,
      :map =>
      "function(doc) {
      if (doc.type == 'Ahoy::Message' && !!doc.template) {
        var opened = (!!doc.opened_at) ? 1 : 0;
        var clicked = (!!doc.clicked_at) ? 1 : 0;
        var template = (!!doc.template) ? doc.template : 'none';
        emit([template, doc.subject, doc.updated_at], [1, opened, clicked]);
      }
      };",
      :reduce => "_sum"
    end

    design do
      view :summary,
      :map =>
      "function(doc) {
      if (doc.type == 'Ahoy::Message') {
        var opened_at = (!!doc.opened_at) ? doc.opened_at : false;
        var clicked_at = (!!doc.clicked_at) ? doc.clicked_at : false;
        emit(doc.to, { mailservice_id: doc.mailservice_id, from: doc.from, template: doc.template, subject: doc.subject, sent_at: doc.sent_at, opened_at: opened_at, clicked_at: clicked_at });
      }
      };"
    end

  end
end
