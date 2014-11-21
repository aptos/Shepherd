
namespace :reports do

	desc "weekly report"
	task :weekly_report => :environment do
		admin = Admin.find('brian@taskit.io')
		client = Gmail::Client.new admin

		db_name = 'taskitone'
		days = 30

		payload = ReportMailer.weekly_report db_name, days

		encoded_payload = Base64.urlsafe_encode64 payload.to_s
		resp = client.send_message encoded_payload
		puts resp
		
	end
end