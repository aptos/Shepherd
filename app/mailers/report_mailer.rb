class ReportMailer < ActionMailer::Base
  include ApplicationHelper

  def weekly_report db_name, days
		days ||= 7

		site = Site.by_slug.key("#{db_name}_#{Rails.env}").first
		@site_label = Shepherd::Application.config.sites.find{|s| s[:db] == db_name}[:label]

		@recent = recent_users days, db_name
		@projects = current_projects db_name
		mail(to: 'brian@taskit.io', from: 'brian@taskit.io', subject: "Weekly Activity for #{@site_label}")
  end
end