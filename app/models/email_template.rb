class EmailTemplate < CouchRest::Model::Base
  property :_id, String
  property :name, String
  property :subject, String
  property :body, String

  timestamps!

  design do
    view :by_name
  end

  def self.update name, message
    template = self.by_name.key(name).first
    template ||= EmailTemplate.create(name: name)
    template.subject = message['subject']
    template.body = depersonalize message['body']
    Rails.logger.info "Heres the template: #{template.inspect}"
    template.save!
  end

  def self.depersonalize message
    paragraphs = message.split("\n\n")
    # remove greeting
    paragraphs.shift

    # remove farewell
    paragraphs.pop

    paragraphs.join("\n\n")
  end

end