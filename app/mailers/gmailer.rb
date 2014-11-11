class Gmailer < ActionMailer::Base

  def standard_email message
    @message = message
    @site_name = 'TaskIT'
    @from = "#{@message['from_name']} <#{@message['from']}>"

    to = ( @message['to'].is_a? Array ) ? @message['to'].first : @message['to']

    track user: Lead.from_uid(to).to_param

    mail(to: @message['to'], from: @from, subject: @message['subject'])
  end

end