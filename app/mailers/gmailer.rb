class Gmailer < ActionMailer::Base

  def standard_email message, utm_params={}
    @message = message
    @from = "#{@message['from_name']} <#{@message['from']}>"

    to = ( @message['to'].is_a? Array ) ? @message['to'].first : @message['to']

    params = { user: Lead.from_uid(to).to_param }
    params.merge! utm_params unless utm_params.empty?
    track params

    mail(to: @message['to'], from: @from, subject: @message['subject'])
  end

end