class Gmailer < ActionMailer::Base

	def standard_email message
		@message = message
		@site_name = 'TaskIT'
		@from = "#{@message['from_name']} <#{@message['from']}>"
		mail(to: @message['to'], from: @from, subject: @message['subject'])
	end
end