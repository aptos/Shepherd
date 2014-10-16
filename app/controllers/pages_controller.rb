class PagesController < ApplicationController

	def index
		render layout: layout_name
	end

	private

	def layout_name
		logger.info "Processing layout for Index #{params[:layout]}"
		if params[:layout] == 0
			false
		else
			'application'
		end
	end


end
