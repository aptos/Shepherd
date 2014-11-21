class ReportsController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json

	def recent
		days = params[:days]
		days ||= 7

		db_name = site.slug.split("_").first
		@site_label = Shepherd::Application.config.sites.find{|s| s[:db] == db_name}[:label]

		@recent = recent_users days, db_name
		@projects = current_projects db_name

		respond_to do |format|
			format.html
			format.json{
				render :json => { site: @site_label, recent: @recent, projects: @projects }
			}
		end
	end

end